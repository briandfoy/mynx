# mynx

Sometimes I just want to read the interesting part of a web page
without all the fluff around it. I could use `lynx` to get a text version,
but that still has all of the cruft. Instead, I'll fetch the page, extract
the main content portion of the DOM, then format that. So, instead of `my_lynx`,
it's just `mynx`.

	% mynx http://www.example.com/some/story

And, I'll do this with host-specific preprocessing.
