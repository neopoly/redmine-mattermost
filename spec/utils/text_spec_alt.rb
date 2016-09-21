require "spec_helper"

describe RedmineMattermost::Utils::Text do
  subject        { Dummy.new(bridge) }
  let(:bridge)   { MockBridge.new(settings) }
  let(:settings) { Defaults.settings }

  describe "h" do
    it "escapes special chars" do
      text = subject.h("some & special <chars>")
      text.must_equal("some &amp; special &lt;chars&gt;")
    end

    it "handles nil inputs" do
      subject.h(nil).must_be_nil
    end
  end

  describe "link" do
    it "builds a markdown link" do
      text = subject.link("the < label", "the_target")
      text.must_equal("<the_target|the &lt; label>")
    end
  end

  describe "to_markdown" do
    it "transforms HTML" do
      input = <<HTML.strip
<h1>Header1</h1>
<h2>Header2</h2>
<p>This is a new comment</p>
<ul>
<li>with multiple items</li>
<li>in a list</li>
</ul>

<p>or a</p>

<ol>
<li>Numbered</li>
<li>List</li>
</ol>

<p>
<del>strike</del> <ins>underline</ins> <em>italic</em> <strong>bold</strong>
</p>

<blockquote>
<p>Block quote</p>
</blockquote>

<p>
<img src="https://www.example.org/image.png" alt="Example Image">
</p>

<p>
External link: <a href="https://www.example.org" class="external">ExampleORG</a>
</p>

<pre>
Some pre-indented text
in two lines
</pre>

<pre><code class="ruby syntaxhl">
class Ruby
end
</code></pre>

HTML
      expected = <<MARKDOWN.strip
# Header1

## Header2

This is a new comment

- with multiple items
- in a list

or a

1. Numbered
2. List

~~strike~~ underline _italic_ **bold**

> Block quote

![Example Image](https://www.example.org/image.png)

External link: [ExampleORG](https://www.example.org)

```
Some pre-indented text
in two lines
```

```
class Ruby
end
```
MARKDOWN
      text = subject.to_markdown(input)
      text.must_equal(expected)
    end

    it "passes already used markdown" do
      settings.text_formatting = "markdown"
      text = subject.to_markdown("> Markdown")
      text.must_equal("> Markdown")
    end

    it "rescues to escaped test" do
      stub = proc do |formatting, text|
        raise "some error"
      end
      bridge.stub(:to_html, stub) do
        text = subject.to_markdown("<code>")
        text.must_equal("&lt;code&gt;")
      end
    end
  end

  private

  class Dummy
    include RedmineMattermost::Utils::Text

    attr_reader :bridge

    def initialize(bridge)
      @bridge = bridge
    end

    # just use the input (assuming the test already)
    # provides valid HTML
    def to_html(formatting, text)
      text
    end
  end
end
