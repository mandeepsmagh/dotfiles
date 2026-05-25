---
name: exa
description: Web search and content extraction via mcp servers. uses exa web search.
---

# Exa Web Search

Use when the user asks to search the web or fetch the content of a URL. No API key required.

## Search the web
exa-search web_search_exa --query "<natural language description of ideal page>"

Optional:
--num-results <number>   # default: 10

Examples:
exa-search web_search_exa --query "llama.cpp tool calling how to enable"
exa-search web_search_exa --query "category:people Andrej Karpathy AI researcher"
exa-search web_search_exa --query "blog post comparing React and Vue performance" --num-results 5

Query tips:
- Describe the ideal page, not keywords
- Use category:people to search LinkedIn profiles
- Use category:company to search company pages
- If results are insufficient, follow up with web_fetch_exa on the best URLs

## Fetch full page content as markdown
exa-search web_fetch_exa --urls <url1,url2,...>

Optional:
--max-characters <number>   # default: 3000

Examples:
exa-search web_fetch_exa --urls https://example.com
exa-search web_fetch_exa --urls https://example.com,https://other.com
exa-search web_fetch_exa --urls https://example.com --max-characters 8000

## Typical workflow
1. Search with web_search_exa to find relevant URLs
2. If the search highlights are not enough, fetch full content with web_fetch_exa

Only load this skill when explicitly asked to search the web or read a URL.
