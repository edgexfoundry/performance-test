#
# Copyright (c) 2019
# Intel
#
# SPDX-License-Identifier: Apache-2.0
#
FROM alpine:3.9

LABEL license='SPDX-License-Identifier: Apache-2.0' \
      copyright='Copyright (c) 2019: Intel'

RUN apk add --update --no-cache jq

ENTRYPOINT ["jq"]
