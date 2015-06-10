# CoreDet
*A Compiler and Runtime System for Deterministic Multithreaded Execution*

Source code releases. This repository is just a hosting platform for the previous source code releases for CoreDet. This code is no longer supported; the code is provided for those interested in replicating the results from two prior ASPLOS papers.

More info about the overall project: [Deterministic Multiprocessing (DMP)](http://sampa.cs.washington.edu/research/dmp.html)

Binary and source code distributions are available from the [Releases page](https://github.com/uwsampa/coredet/releases).

See the README.asplos2010 file for build instructions.

### Known Bugs

A file is missing from the full distributions (not the srconly distributions). That file is benchmarks/parsec/config/llvm-default.bldconf and can be found [here](llvm-default.bldconf) (in this repo).

The do-asplos10-benchmarks.sh script will fail in meta-benchmark-manager.py with a regular expressions error at line 504. That entire block of code was used during local development and should be removed (lines 504-512, starting at “# git revision info”).

### Configuration script

The script we use to setup CoreDet on a new machine can be found [here](setuphost.sh).
