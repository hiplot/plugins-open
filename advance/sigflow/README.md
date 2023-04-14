## [Sigflow](/advance/sigflow)

Sigflow provides useful mutational signature analysis workflows. It can auto-extract mutational signatures, fit mutation data to all/specified COSMIC reference signatures (SBS/DBS/INDEL).

There is something you need to know when you use this plugin.

1. This plugin is not a complete version, if you want more features, refer to <https://github.com/ShixiangWang/sigflow>.
2. `MAF` in `Mode` parameter means `SBS` + `DBS` + `INDEL`.
3. If you set the `Maximum Signature Number` to `-1`, it will automatically set the maximum signature number based on the mutation type you want to extract signatures.
4. Option `Number of NMF runs` typically set to 30-50.