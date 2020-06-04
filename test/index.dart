import "ast_exhaustive_field_test.dart" as ast_exhaustive_field_test;
import "ast_layout_parser_test.dart" as ast_layout_parser_test;
import "fn_ptr_parser_test.dart" as fn_ptr_parser_test;
import "irgen_layout_parser_test.dart" as irgen_layout_parser_test;
import "layout_parser_transition_test.dart" as layout_parser_transition_test;
import "ptr_syntax_test.dart" as ptr_syntax_test;
import "translate_type_test.dart" as translate_type_test;

void main() {
  ast_exhaustive_field_test.main();
  ast_layout_parser_test.main();
  fn_ptr_parser_test.main();
  irgen_layout_parser_test.main();
  layout_parser_transition_test.main();
  ptr_syntax_test.main();
  translate_type_test.main();
}
