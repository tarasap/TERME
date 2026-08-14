# Memory/Write-Back Unit (MWB Stage)

## Overview

The `Memory_WriteBack` module implements the final stage of the TERME
three-stage pipeline.

TERME uses the following pipeline organization:

        Fetch              Decode/Execute          Memory/Write-Back

          F  ---------------- DEX ---------------- MWB


