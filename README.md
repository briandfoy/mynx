# mynx

Sometimes I just want to read the interesting part of a web page
without all the fluff around it. I could use `lynx` to get a text version,
but that still has all of the cruft. Instead, I'll fetch the page, extract
the main content portion of the DOM, then format that. So, instead of `my_lynx`,
it's just `mynx` (minks). It's kinda like a cat, but just different.

	% script/mynx http://www.example.com/some/story

And, I'll do this with host-specific preprocessing.

This is not a web browser and I don't care about following links. In
that case I can just use `lynx`. Fetch the single page, read it, and
move on in life.

![](images/minks.jpg)
