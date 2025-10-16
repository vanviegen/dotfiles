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

ALIASES = {
    "sonnet": "anthropic/claude-sonnet-4.5",
    "s": "anthropic/claude-sonnet-4.5",
    "gemini": "google/gemini-2.5-pro",
    "g": "google/gemini-2.5-pro",
    "qwen": "qwen/qwen3-vl-8b-instruct",
    "q": "qwen/qwen3-vl-8b-instruct",
    "gpt": "openai/gpt-4.1",
    "4": "openai/gpt-4.1",
    "gemini-flash-lite": "google/gemini-2.5-flash-lite",
    "gf": "google/gemini-2.5-flash-lite",
}

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
parser.add_argument('-e', '--edit', action='append', default=[], help="Have the LLM edit this file. Can be used multiple times.")
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
SEARCH = "<<<<<<< SEARCH"

# Compose the list off messages
if args.repeat or args._continue or args.last:
    with open(LAST_QUERY_FILE) as f:
        messages = json.load(f)
    if args.repeat:
        messages.pop()
elif args.edit:
    messages = [
        {"role": "system", "content": """You are a non-agentic coding assistant. The user will provide you with a prompt describing what should be done, and an input file for you to edit. Your output should consists of your analysis of the problem and notes on what steps to take (this part of your output will be ignored, it's only to help your own thinking, so be brief, capture your thoughts in a bulleted list with little words), followed by a separator line consisting of only three dashes (---), followed by either:
         
1. The full modified file (preferable if significant parts of the file are to be edited). If you choose this option, make sure you output the full file, including any parts that are unchanged.

or
               
2. One or more "{SEARCH}\n" <old code> "=======\n" <new code> ">>>>>>>\n". Make sure both <old code> and <new code> blocks contain only full lines, including the newline character. Make very sure the <old code> block exactly matches the corresponding part of the input file, otherwise the patch will not apply. If there's a change the <old code> block is not unique within the file, expand the block with additional (unchanged) lines until it is unique (adding the corresponding newlines to the <new block> as well).

Example output:
```
- Goal: fix spelling mistakes and unclear wording in inline documentation
- Spotted several issues to fix
- Changes are local and spawn only a fraction of the file => provide replacements
---
{SEARCH}
 * are processed asynchronously in a batch after a brief timeout (0ms). This function
 * allows you to bypass the timeout and process the update queue immediately.
 *
 * This can be usefull in specific scenarios where you need the DOM to be updated
 * synchronously.
 *
 * This function is re-entrant, meaning it is safe to call `runQueue` from within
=======
 * are processed asynchronously in a batch after a brief timeout (0ms). This function
 * allows you to bypass the timeout and process the update queue immediately.
 *
 * This can be useful in specific scenarios where you need the DOM to be updated
 * synchronously.
 *
 * This function is re-entrant, meaning it is safe to call `runQueue` from within
>>>>>>> REPLACE
{SEARCH}
	sortedSet: ReverseSortedSet<OnEachItemScope, "sortKey"> =
		new ReverseSortedSet("sortKey");

	/** Indexes that has been created/removed and need to be handled in the next `queueRun`. */
	changedIndexes: Set<any> = new Set();

	constructor(
=======
	sortedSet: ReverseSortedSet<OnEachItemScope, "sortKey"> =
		new ReverseSortedSet("sortKey");

	/** Indexes that have been created/removed and need to be handled in the next `queueRun`. */
	changedIndexes: Set<any> = new Set();

	constructor(
>>>>>>> REPLACE
{SEARCH}
export function proxy<T extends any>(target: T): ValueRef<T extends number ? number : T extends string ? string : T extends boolean ? boolean : T>;

/**
 * Creates a reactive proxy around the.
 *
 * Reading properties from the returned proxy within a reactive scope (like one created by
 * {@link A} or {@link derive}) establishes a subscription. Modifying properties *through*
 * the proxy will notify subscribed scopes, causing them to go.
 *
 * - Plain objects and arrays are wrapped in a standard JavaScript `Proxy` that intercepts
 *   property access and mutations, but otherwise works like the underlying data.
=======
export function proxy<T extends any>(target: T): ValueRef<T extends number ? number : T extends string ? string : T extends boolean ? boolean : T>;

/**
 * Creates a reactive proxy around the given data.
 *
 * Reading properties from the returned proxy within a reactive scope (like one created by
 * {@link A} or {@link derive}) establishes a subscription. Modifying properties *through*
 * the proxy will notify subscribed scopes, causing them to re-execute.
 *
 * - Plain objects and arrays are wrapped in a standard JavaScript `Proxy` that intercepts
 *   property access and mutations, but otherwise works like the underlying data.
>>>>>>> REPLACE
```

Example output:
```
- Need file watching without external deps - use polling since no built-in inotify in Python stdlib
- `tail -f` replacement: open file, seek to end, read new lines continuously
- Signal handling not needed - Ctrl+C naturally raises KeyboardInterrupt
- Main loop: check file exists → tail it until gone → repeat
- Track file position and inode to detect deletion/recreation
---
#!/usr/bin/env python3

import sys
import os
import time

if len(sys.argv) != 2:
    print("Continuously tail a file even when it's deleted and recreated")
    print(f"Usage: {sys.argv[0]} <file_path>", file=sys.stderr)
    sys.exit(1)

FILE_PATH = sys.argv[1]

try:
    while True:
        if os.path.isfile(FILE_PATH):
            with open(FILE_PATH, 'r') as f:
                # Start from end
                f.seek(0, os.SEEK_END)
                inode = os.fstat(f.fileno()).st_ino
                
                while True:
                    line = f.readline()
                    if line:
                        print(line, end='')
                    else:
                        # Check if file still exists with same inode
                        try:
                            if not os.path.exists(FILE_PATH) or \
                               os.stat(FILE_PATH).st_ino != inode:
                                break
                        except OSError:
                            break
                        time.sleep(0.1)
                
            print("----------------------------------")
        
        time.sleep(0.1)

except KeyboardInterrupt:
    sys.exit(0)
```

         """},
    ]
else:
    messages = [
        {"role": "system", "content": "You are a command-line virtual assistant. The user can ask you questions about any topic, to which you will provide a short but precise answer. If the user asks you to write code, make sure to put the output in a code block with the proper language marker. Assume `fish` as my shell. Python can be used for cases where shell scripting is impractical. Don't repeat the question in your reply. Don't summarize at the end of your reply. Just a code block is fine, if the code speaks for itself."},
    ]

        
model = ALIASES.get(args.model, args.model)


def query(messages):
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
    return response['choices'][0]['message']['content']


if args.last:
    text = messages.pop()["content"]
else:
    # Add new prompt(s) to the message lists
    for filename in args.file:
        with open(filename) as f:
            messages.append({"role": "user", "content": f"{filename}:\n```\n{f.read().rstrip()}\n```"})
    if prompt:
        messages.append({"role": "user", "content": prompt})

    if args.edit:        
        for file in args.edit:
            print(f"Processing '{file}' using {model}...")
            copy = messages
            with open(file) as f:
                inData = f.read()

            copy.append({"role": "user", "content": f"My following message is the input file '{file}' you should work on."})
            copy.append({"role": "user", "content": inData})

            out = query(messages)
            reasoning, delta = out.split("\n---\n", 1)
            print(reasoning.strip())

            if "<<<<<<" not in delta:
                outData = delta
                print(f"* Replaced full file ({inData.count('\n')+1} -> {outData.count('\n')+1} lines)")
            else:
                # Apply patch
                outData = inData
                def repl(m):
                    global outData
                    a = m.group(1)
                    b = m.group(2)
                    cnt = outData.count(a)
                    if cnt == 0:
                        print(f"* ERROR: Could not find chunk to replace:")
                        print(a)
                        exit(1)
                    if cnt > 1:
                        print(f"* ERROR: Chunk to replace is not unique ({cnt} matches):")
                        print(a)
                        exit(1)

                    outData = outData.replace(a, b, 1)
                    print(f"* Replaced chunk ({a.count('\n')+1} -> {b.count('\n')+1} lines)")
                    return ''
                remain = re.sub(r"^<<<<<<+\s*(?:SEARCH)?\s*\n([\s\S]*?\n)======+\s*\n([\s\S]*?\n)>>>>>>+\s*(?:REPLACE)?\s*$", repl, delta)
                if remain.strip():
                    print("* ERROR: Some parts of the patch could not be applied:\n")
                    print(delta)
                    exit(1)

            if subprocess.run(["git", "diff", "--quiet", "HEAD", "--", file]).returncode:
                print(f"* Creating backup {file + ".bak"}")
                with open(file + ".bak", "w") as f:
                    f.write(inData)
            else:
                print(f"* Skipping backup (file committed in git)")

            with open(file, "w") as f:
                f.write(outData)

        exit()
    else:
        print(f"Querying {model}...", end="", flush=True)
        text = query(messages)    


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

