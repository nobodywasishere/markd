require "./spec_helper"

describe "GFM footnotes" do
  it "leaves ordinary caret-prefixed link labels available in CommonMark mode" do
    Markd.to_html("See [^note].\n\n[^note]: /url").should eq(%(<p>See <a href="/url">^note</a>.</p>\n))
  end

  it "parses explicit caret-prefixed links as links in GFM mode" do
    options = Markd::Options.new(gfm: true)
    Markd.to_html("[^*name*](path)\n\n[^*name*]: note", options).should eq(
      %(<p><a href="path">^<em>name</em></a></p>\n)
    )
  end

  it "matches labels case-insensitively and uses the first definition" do
    html = Markd.to_html("See [^ä].\n\n[^Ä]: first\n[^ä]: second", Markd::Options.new(gfm: true))
    html.should contain(%(<a href="#fn-%C3%84" id="fnref-%C3%84" data-footnote-ref>1</a>))
    html.should contain("<p>first ")
    html.should_not contain("second")
  end

  it "renders cited definitions once even when notes cite each other" do
    input = "See [^a].\n\n[^a]: A [^b].\n\n[^b]: B [^a].\n\n[^unused]: Hidden [^also-unused].\n\n[^also-unused]: Hidden too."
    html = Markd.to_html(input, Markd::Options.new(gfm: true))
    html.scan(/<li id="fn-([ab])">/).map(&.[1]).should eq(%w[a b])
    html.should contain(%(<a href="#fn-a" id="fnref-a-2" data-footnote-ref>1</a>))
    html.should contain(%(<a href="#fnref-a-2" class="footnote-backref"))
    html.should_not contain("Hidden")
  end

  it "resolves a note after an unmatched image opener in another paragraph" do
    input = "![unfinished\n\nSee [^note].\n\n[^note]: Footnote."
    html = Markd.to_html(input, Markd::Options.new(gfm: true))
    html.should contain("<p>![unfinished</p>")
    html.should contain(%(See <sup class="footnote-ref"><a href="#fn-note"))
    html.should contain(%(<li id="fn-note">))
  end
end
