#!/usr/bin/env python3
import subprocess
import sys
import os
import re
import argparse
import json
import urllib
import urllib.request

import pyperclip
import prompt_toolkit

def request(url, data, headers):
    try:
        req = urllib.request.Request(url, data=json.dumps(data).encode('utf-8'), headers=headers)
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        print("\nLLM error:", json.loads(e.read().decode('utf-8')))
        exit(1)

parser = argparse.ArgumentParser(
    prog="ai",
    description="Ask an LLM for help on the command line.",
    epilog="Additional query arguments can be passed anywhere in the command. These arguments will be used as the query. If there is no query, the user is pronpted.",
)
parser.add_argument('-m', '--model', type=str, default='sonnet', help="Set the model name (default: 'sonnet').")
parser.add_argument('-c', '--continue', dest='_continue', action='store_true', help="Continue the previous conversation.")
parser.add_argument('-f', '--file', action='append', default=[], help="Pass file(s) to the LLM. Can be used multiple times.")
parser.add_argument('-r', '--repeat', action='store_true', help="Repeat the previous query.")
parser.add_argument('-l', '--last', action='store_true', help="Show the last response again.")
parser.add_argument('-k', '--key', type=str, help="Set the LLM API key. Default to using OPENAI_API_KEY or ANTHROPIC_API_KEY environment variable.")

args, query = parser.parse_known_args()

# Get a prompt from the user
if len(query) > 0 or args.repeat or args.last:
    prompt = " ".join(query) 
else:
    print("Type query and press alt-enter:")
    prompt = prompt_toolkit.prompt("> ", prompt_continuation="> ", multiline=True).rstrip()

# Add stdin data to the prompt
if not sys.stdin.isatty():
    data = sys.stdin.read()
    prompt += f"\n\n```\n{data.rstrip()}\n```"

if not prompt and not args.repeat and not args.last:
    exit()

LAST_QUERY_FILE = os.path.join(os.path.expanduser('~'), '.ai-last-query.json')

# Compose the list off messages
if args.repeat or args._continue or args.last:
    with open(LAST_QUERY_FILE) as f:
        messages = json.load(f)
    if args.repeat:
        messages.pop()
else:
    messages = [
        {"role": "system", "content": "You are a command-line virtual assistant. The user can ask you questions about any topic, to which you will provide a short but precise answer. If the user asks you to write code, make sure to put the output in a code block with the proper language marker. Assume `zsh` script as the default programming language. Python can be used for cases where shell scripting is impractical. Don't repeat the question in your reply. Don't summarize at the end of your reply. Just a code block is fine, if the code speaks for itself."},
    ]

if args.last:
    text = messages.pop()["content"]
else:
    # Add new prompt(s) to the message lists
    for filename in args.file:
        with open(filename) as f:
            messages.append({"role": "user", "content": f"{filename}:\n```\n{f.read().rstrip()}\n```"})
    if prompt:
        messages.append({"role": "user", "content": prompt})
        
    # Model aliases and model specific tweaks
    model = {"4o": "gpt-4o", "4o-mini": "gpt-4o-mini", "4om": "gpt-4o-mini", "o1m": "o1-mini", "o1": "o1-preview", "sonnet": "claude-3-5-sonnet-20240620", "s": "claude-3-5-sonnet-20240620", "haiku": "claude-3-haiku-20240307", "h": "claude-3-haiku-20240307"}.get(args.model, args.model)
    if model.startswith("o1") or model.startswith("claude-"):
        for message in messages:
            if message['role'] == 'system':
                message['role'] = 'user'

    # Get a response from the LLM
    print(f"Querying {model}...", end="", flush=True)
    headers = {'Content-Type': 'application/json',}
    data = {
        'model': model,
        'messages': messages,
    }
    if model.startswith("claude-"):
        data['max_tokens'] = 4096
        headers['anthropic-version'] = '2023-06-01'
        headers['x-api-key'] = args.key or os.environ["ANTHROPIC_API_KEY"]
        response = request("https://api.anthropic.com/v1/messages", data, headers)
        text = response['content'][0]['text']
    else:
        headers['Authorization'] = 'Bearer ' + (args.key or os.environ["OPENAI_API_KEY"])
        response = request("https://api.openai.com/v1/chat/completions", data, headers)
        text = response['choices'][0]['message']['content']
        
# Highlight any code block and copy it to the clipboard
def found_code_block(m):
    try:
        pyperclip.copy(m.group(2))
    except pyperclip.PyperclipException:
        pass
    return f"```{m.group(1)}\n\033[92m{m.group(2)}\033[0m\n```"
text = re.sub(r"^```(.*)\n([\w\W]*)\n```", found_code_block, text)

# Show result
print("\r\033[K" + text)

# Write query and response to a file
messages.append({"role": "assistant", "content": text})
with open(LAST_QUERY_FILE, "w") as f:
    json.dump(messages, f)

