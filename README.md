# Japanese Vocabulary Estimator

Estimate how many Japanese words you know with a margin of error.

Using the top 8000 words from the JPDB CSV file from https://github.com/Kuuuube/yomitan-dictionaries. Some are not real words (for example "んだ" is in the list) but I've intentionally left it untouched.

Deployed at https://afninfa.github.io/Japanese-Vocabulary-Estimator/

### Improvements (TODO)

Before sharing online I want to

- [x] Make sure every `let assert` in the code prints a helpful message
- [ ] Find all repeated code and refactor into HOFs. For example, the logic "for each bucket, if the bucket ID equals the active bucket ID, then do ..." is now a HOF.
- [ ] Make the bucket proportion calculation, overall estimation and margin of error functions all return optionals. And display a placeholder in the UI if they're not present.
- [ ] Make the UI visually appealing for the estimation and margin of error part (above the buckets).
- [ ] Put some text like "1-1000", "1001-2000" etc. above or below each bucket. But keep the number of samples remaining from each bucket as well.
- [ ] Best effort to make sure the statistics calculations are correct. Maybe can use unit tests for this.
