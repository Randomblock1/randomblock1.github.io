---
title: "Use Cursor Composer 2.5 Anywhere With an OpenAI-Compatible API"
categories:
  - blog
tags:
  - AI
---

## TL;DR

I built [cursor-openai-api](https://github.com/Randomblock1/cursor-openai-api), a small HTTP server that speaks OpenAI's API but routes every request through the [Cursor SDK](https://cursor.com/docs/sdk/typescript). Point any OpenAI client (like OpenCode, OpenClaw, your own scripts, whatever) at it, and you get Composer 2.5 (and every other model Cursor exposes) with your Cursor plan's usage.

And the timing is good: [**Cursor just announced Composer via the SDK is 90% off this weekend.**](https://x.com/cursor_ai/status/2057913121558413770) Composer is already one of the best agentic coding models out there for the price, and at a 90% discount it feels almost free. It's a great excuse to actually try it in your own tools, and to use the more expensive Fast Mode.

## Why this exists

Cursor's editor is great, but Composer is locked behind it. If you wanted to use it in a script, in OpenCode, in a custom agent, or just hit it from `curl`, you couldn't. The [Cursor SDK](https://cursor.com/docs/sdk/typescript) opened the door, but almost everything expects OpenAI's `/v1/chat/completions` shape, not a vendor-specific SDK. The Cursor SDK also has a different way of handling tool calls and thinking, which OpenAI clients don't know how to parse.

So I wrote an adapter. The proxy is a [Hono](https://hono.dev/) server that translates OpenAI requests into Cursor SDK calls, streams that back as SSE chunks, and maps thinking, tool calls, and usage into the fields OpenAI clients already know how to parse.

The result is that anything that takes a `base_url` and an `api_key` Just Works:

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8080/v1",
    api_key="onlyNeededIfYouSetIt",
)

response = client.chat.completions.create(
    model="composer-2.5",
    messages=[{"role": "user", "content": "Refactor this function."}],
)
print(response.choices[0].message.content)
```

That's it. Same code, different LLM.

A few nice details I added to make using it easier:

- **Speed aliases.** Composer defaults to Fast Mode in Cursor's catalog. To use the less expensive standard tier you'd normally pass `cursor_model_params: [{ "id": "fast", "value": "false" }]`, which is annoying, and may require code changes. The proxy auto-generates `<model>-slow` and `<model>-fast` aliases for every model that supports both, so you can just ask for `composer-2.5-slow`. This also works for other models, like `gpt-5.5` that has the `fast` parameter.
- **Thinking interleave for OpenCode.** [`@ai-sdk/openai-compatible`](https://ai-sdk.dev/providers/openai-compatible-providers) collapses all `content` into a single text block per stream, which mangles ordering when the model interleaves thinking and text. There's a special `preamble-as-reasoning` mode that re-routes buffered text into `reasoning_content` when the model crosses a thinking or tool boundary, so OpenCode renders **Thought → Response** in the right order.

  In other words, it has a compatibility mode for OpenCode's way of rendering thinking, so it doesn't break because Cursor works a little differently.
- **Client tool loops.** If the request includes a `tools` array, the proxy enters client-tool-loop mode: it instructs the model to emit Composer tool-call markers for your tool names, parses them out of the text stream, and returns OpenAI `tool_calls` with `finish_reason: "tool_calls"`. Your client executes them locally and the conversation continues. This is what makes things like OpenCode's tool-using agents work with Composer as the backend.
- **Abort support.** Drop the HTTP connection and the in-flight `run.cancel()` fires. No need to waste tokens on a response that won't be read.

## Why it's useful

A few things I've actually used it for:

- **OpenCode with Composer 2.5.** OpenCode is a terminal coding agent that talks to any OpenAI-compatible endpoint. Pointing it at the proxy gets you Composer with the full tool loop (file edits, shell, search) in a TUI instead of Cursor's editor.
- **One-off scripts.** Need to generate something from a CLI, a `Makefile`, a cron job? `curl http://localhost:8080/v1/chat/completions` with the model id and you're done. No editor required.
- **Existing agents.** If you're building anything on top of the OpenAI SDK, like eval harnesses, code review bots, batch refactors, you can swap the model to Composer by changing the base URL. Your retry logic, token counting, tracing, etc. all still work.
- **Comparison/benchmark.** Run the same prompt against `composer-2.5`, `claude-opus-4-7`, and `gpt-5.5` from the same script and compare the output. Cursor's catalog has a lot of models behind one key; this exposes all of them through one endpoint.

## Try it this weekend

Setup is three commands:

```bash
git clone https://github.com/Randomblock1/cursor-openai-api
cd cursor-openai-api
bun install # or npm install

export CURSOR_API_KEY="crsr_..."  # from cursor.com/dashboard/integrations
bun run start # or npm run start:node
```

Then point your favorite OpenAI client at `http://localhost:8080/v1` with `composer-2.5` as the model. While Composer is 90% off for the weekend ([per Cursor](https://x.com/cursor_ai/status/2057913121558413770)) it's basically free to put through its paces.

Enjoy!
