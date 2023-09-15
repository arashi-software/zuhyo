# TODO: rebrand to zuhyo

import puppy, tables, jsony

type InquireClient* = ref object
  url*: string

type
  Variables* = Table[string, string]
  Query* = object
    query*: string
    variables*: Variables

template vars*[A, B](ctx: openArray[(A, B)]): Variables = 
  ## Converts a table into the Variables type
  ## .. code:: nim
  ##   let someVariables = vars {"<var_name>": "<var_val>"}
  toTable(ctx)

proc dumpHook*(s: var string, v: Variables) = s.add $v

proc newClient*(url: string): InquireClient =
  ## Create a new inquire client
  ## .. code:: nim
  ##   let api = inquire.newClient("<some_url>")
  return InquireClient(url: url)

proc readQuery*(filename: string, v: Variables): Query =
  ## Read a graphql query from `filename` and use the variables `v`
  ## .. code:: nim
  ##   let query = "<some_filename>".readQuery(vars {"<var_name>": "<var_val>"})
  return Query(
    query: readFile filename,
    variables: v  
  )

proc newQuery*(body: string, v: Variables): Query =
  ## Create a query from `body` using variables `v`
  ## .. code:: nim
  ##   let query = newQuery("<query_text>", vars {"<var_name>": "<var_val>"})
  return Query(
    query: body,
    variables: v
  )

proc request*(api: InquireClient, query: Query): Response =
  ## Request a response from the api provided in `InquireClient` using the `query`
  ## .. code:: nim
  ##   let 
  ##     api = inquire.newClient("<some_url>") 
  ##     query = "<some_filename>".readQuery(vars {"<var_name>": "<var_val>"})
  ##     req = api.request(query) 
  ##
  ##   echo req.code 
  ##   echo req.headers 
  ##   echo req.body 
  return post(
    api.url,
    @[("Content-Type", "application/json")],
    toJson(query)
  )