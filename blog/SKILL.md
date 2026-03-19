---
name: blog
description: Draft a blog post from the current conversation for jnye.co. Use when user wants to write a blog post, capture insights, or mentions "/blog draft".
argument-hint: <topic-slug>
---

# Blog Draft

Draft a blog post from the current conversation and save it to `~/Developer/jnyecode/jnye.blog/drafts/`.

## Arguments

- `$1` (optional): Topic slug in kebab-case (e.g., "nextjs-caching")

User input: $ARGUMENTS

## Steps

### 1. Get the topic slug

If no slug provided, suggest one based on the conversation and ask the user to confirm.

### 2. Generate the next post ID

Find the highest existing `id` in published posts:

```bash
grep -h '^id:' ~/Developer/jnyecode/jnye.blog/src/content/posts/*.md | sed 's/id: //' | sort -n | tail -1
```

Increment by 1. This becomes the draft's `id`.

### 3. Review the conversation

Extract:
- The problem or challenge
- The approach taken and why it worked
- Technologies involved
- Key code snippets
- Gotchas, surprises, or lessons learned
- The narrative arc — what makes this interesting to a reader

### 4. Write the draft

Save to: `~/Developer/jnyecode/jnye.blog/drafts/{YYYY-MM-DD}-{topic-slug}.md`

Use this format:

```markdown
---
id: {next sequential id}
topic: {topic-slug}
date: {YYYY-MM-DD}
project: {current working directory}
tags: [{relevant tags}]
status: draft
---

# {Compelling Title}

{Full narrative blog post draft — not an outline, not bullet points, but prose
that another writer (human or AI) could take and polish into a published post.

Structure naturally based on the content. Most posts will follow something like:
problem → journey → solution → gotchas → takeaway, but let the content dictate
the structure rather than forcing a template.

Include code snippets where they add value. Keep them focused — show the key
insight, not the full file.

Write in first person. Be direct. Skip filler.}
```

### 5. Offer title alternatives

After writing the draft, suggest 2-3 alternative titles:
- One problem-focused
- One solution-focused
- One that leads with the surprising insight

### 6. Confirm

Tell the user the filename and offer to revise any section.

## Published post format (reference)

When a draft is ready to publish, it moves to `src/content/posts/` with this frontmatter:

```yaml
id: {number}
title: "{title}"
urlSlug: "{slug}"
created: "{ISO-8601}"
seoDescription: "{150-160 chars}"
shortIdentifier: "{6-char alphanumeric}"
tags: [{tags}]
```

Do not create the published version — only the draft. The user will promote it manually.

## Guidelines

- Write a real draft, not an outline or raw notes
- Synthesise — find the narrative thread, don't just dump everything from the conversation
- Be selective about what to include; not every detail is interesting to a reader
- If screenshots would help, ask: "Would a screenshot of [specific thing] help illustrate this?"
