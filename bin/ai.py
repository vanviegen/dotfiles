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
    epilog="Additional query arguments can be passed anywhere in the command. These arguments will be used as the query. If there is no query, the user is prompted.",
)
parser.add_argument('-m', '--model', type=str, default='sonnet', help="Set the model name (default: 'sonnet').")
parser.add_argument('-c', '--continue', dest='_continue', action='store_true', help="Continue the previous conversation.")
parser.add_argument('-f', '--file', action='append', default=[], help="Pass file(s) to the LLM. Can be used multiple times.")
parser.add_argument('-r', '--repeat', action='store_true', help="Repeat the previous query.")
parser.add_argument('-l', '--last', action='store_true', help="Show the last response again.")
parser.add_argument('-k', '--key', type=str, help="Set the OpenRouter API key. Default to using OPENROUTER_API_KEY environment variable.")

args, query = parser.parse_known_args()

# Get a prompt from the user
if len(query) > 0 or args.repeat or args.last or not sys.stdin.isatty():
    prompt = " ".join(query) 
    # Add stdin data to the prompt
    if not sys.stdin.isatty():
        data = sys.stdin.read()
        prompt += f"\n\n```\n{data.rstrip()}\n```"
elif not sys.stdin.isatty():
    prompt = sys.stdin.read()
else:
    print("Type query and press alt-enter:")
    prompt = prompt_toolkit.prompt("> ", prompt_continuation="> ", multiline=True).rstrip()


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
        {"role": "system", "content": "You are a command-line virtual assistant. The user can ask you questions about any topic, to which you will provide a short but precise answer. If the user asks you to write code, make sure to put the output in a code block with the proper language marker. Assume `fish` as my shell. Python can be used for cases where shell scripting is impractical. Don't repeat the question in your reply. Don't summarize at the end of your reply. Just a code block is fine, if the code speaks for itself."},
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
    model = {
        "sonnet": "anthropic/claude-sonnet-4",
        "s": "anthropic/claude-sonnet-4",
        "gemini": "google/gemini-2.5-pro",
        "g": "google/gemini-2.5-pro",
        "qwen": "qwen/qwen3-30b-a3b",
        "q": "qwen/qwen3-30b-a3b",
        "gpt": "openai/gpt-4.1",
        "4": "openai/gpt-4.1"
    }.get(args.model, args.model)
    
    # Remove system messages for models that don't support them
    if model.startswith("anthropic/") or model.startswith("openai/o1"):
        for message in messages:
            if message['role'] == 'system':
                message['role'] = 'user'

    # Get a response from OpenRouter
    print(f"Querying {model}...", end="", flush=True)
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {args.key or os.environ["OPENROUTER_API_KEY"]}',
        'HTTP-Referer': 'https://github.com/vanviegen/dotfiles',
        'X-Title': 'AI CLI Tool'
    }
    data = {
        'model': model,
        'messages': messages,
    }
    
    response = request("https://openrouter.ai/api/v1/chat/completions", data, headers)
    text = response['choices'][0]['message']['content']
        
# Write query and response to a file
messages.append({"role": "assistant", "content": text})
with open(LAST_QUERY_FILE, "w") as f:
    json.dump(messages, f)

# Highlight any code block and copy it to the clipboard
def found_code_block(m):
    try:
        pyperclip.copy(m.group(2))
    except pyperclip.PyperclipException:
        pass
    return f"```{m.group(1)}\n\033[92m{m.group(2)}\033[0m\n```"
text = re.sub(r"^```(.*)\n([\s\S]*?)\n```", found_code_block, text, flags=re.MULTILINE)

# Show result
print("\r\033[K" + text)

