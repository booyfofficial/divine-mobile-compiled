## Mandatory Development Process

### TDD Workflow (NON-NEGOTIABLE)
1. **RED Phase**: Write failing test FIRST
   - Create test file before implementation file
   - Test must fail with clear assertion error
   - Commit: `test: Add failing test for [feature]`
   
2. **GREEN Phase**: Minimal implementation
   - Write ONLY enough code to pass test
   - No extra features or optimizations
   - Commit: `feat: Implement [feature] to pass tests`
   
3. **REFACTOR Phase**: Clean and review
   - Run code review checklist
   - Remove all TODOs
   - Consolidate duplicate code
   - Commit: `refactor: Clean up [feature] implementation`

### Code Review Checklist (MUST COMPLETE)
- [ ] Zero TODOs remaining in code
- [ ] No duplicate functions/classes with similar names
- [ ] No commented-out code blocks
- [ ] All functions have single responsibility (≤30 lines)
- [ ] Error handling on all external calls
- [ ] Test coverage ≥80%
- [ ] No `Future.delayed()` or arbitrary timers
- [ ] No placeholder implementations
- [ ] All edge cases handled