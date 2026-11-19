module Markd::Rule
  struct FootnoteDefinition
    include Rule

    def match(parser : Parser, container : Node) : MatchValue
      return MatchValue::None if !parser.gfm? || parser.indented || parser.line[parser.next_nonspace]? != '['
      marker = Rule::FOOTNOTE_DEFINITION.match(parser.line[parser.next_nonspace..]) || return MatchValue::None

      parser.close_unmatched_blocks
      definition = parser.add_child(Node::Type::FootnoteDefinition, parser.next_nonspace)
      definition.data["label"] = marker[1]
      parser.advance_offset(parser.next_nonspace - parser.offset + marker[0].size)
      MatchValue::Container
    end

    def continue(parser : Parser, container : Node) : ContinueStatus
      if parser.indent >= Rule::CODE_INDENT
        parser.advance_offset(Rule::CODE_INDENT, true)
        ContinueStatus::Continue
      elsif parser.blank
        ContinueStatus::Continue
      else
        ContinueStatus::Stop
      end
    end

    def token(parser : Parser, container : Node) : Nil
    end

    def can_contain?(type : Node::Type) : Bool
      !type.item?
    end

    def accepts_lines? : Bool
      false
    end
  end
end
