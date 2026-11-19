require "./spec_helper"

describe "Older CommonMark and Markd regressions" do
  it "preserves text following a partially consumed tab" do
    Markd.to_html("* foo\n\tbar").should eq("<ul>\n<li>foo\nbar</li>\n</ul>\n")
  end

  it "recognizes type 7 HTML blocks with trailing spaces" do
    Markd.to_html("<a>  \nx").should eq("<a>  \nx\n")
  end

  it "uses Chinese punctuation to determine emphasis boundaries" do
    Markd.to_html("**。**话").should eq("<p>**。**话</p>\n")
  end

  it "treats an escaped closing reference bracket as literal" do
    Markd.to_html("[\\]: test").should eq("<p>[]: test</p>\n")
  end

  it "recognizes an underscore emphasis opener after a caret" do
    Markd.to_html("^_test_").should eq("<p>^<em>test</em></p>\n")
  end

  it "allows tabs around an ATX closing marker" do
    Markd.to_html("# foo\t#\t").should eq("<h1>foo</h1>\n")
  end

  it "rejects an escaped space in an unbracketed link destination" do
    Markd.to_html("[link](a\\ b)").should eq("<p>[link](a\\ b)</p>\n")
  end

  it "treats long digit sequences as ordinary text" do
    Markd.to_html("1212121212121").should eq("<p>1212121212121</p>\n")
  end

  it "allows a search HTML block to interrupt a paragraph" do
    Markd.to_html("foo\n<search>\n*text*").should eq("<p>foo</p>\n<search>\n*text*\n")
  end
end
