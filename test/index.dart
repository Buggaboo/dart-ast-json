import "test/ast_exhaustive_field_test.dart" as ast_exhaustive_field_test;
import "test/ast_layout_parser_test.dart" as ast_layout_parser_test;
import "test/fn_ptr_parser_test.dart" as fn_ptr_parser_test;
import "test/irgen_layout_parser_test.dart" as irgen_layout_parser_test;
import "test/layout_parser_transition_test.dart" as layout_parser_transition_test;
import "test/ptr_syntax_test.dart" as ptr_syntax_test;

void main() {
  ast_exhaustive_field_test.main();
  ast_layout_parser_test.main();
  fn_ptr_parser_test.main();
  irgen_layout_parser_test.main();
  layout_parser_transition_test.main();
  ptr_syntax_test.main();
}
