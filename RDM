mopse-core: core awk lib e.g. array/xml/utils

each module is a part of pipeline:
    - mopse-boot: reading CLI args and whole input, boots pipeline in END
    - mopse-pure: removing newlines, comments, maybe converting some syntax features
    - mopse-translator: translates the pure language to inline XML
    - mopse-beautifier: improves readability of output XML (tabs/nls/etc..)

each module building process:
    1. merge all module sources (e.g. /src/translator)
    2. merge all mopse-core sources (e.g. /src/core)
    3. merge mopse-core and module built
    4. store as file

regular run:
    1. mopse-boot is an entry point, which also validates modules existance

portable run:
    1. sh script contains all the modules in strings
    2. sh script tries to create dir .mopse in pwd
        - if not succeed - try to create in /tmp. If fail again then error
    3. sh script creates README file with mopse quick description
    4. sh script creates modules as files in .mopse dir
    5. sh script runs mopse-boot, so it finds modules in its dir