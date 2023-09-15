import puppy, tables, jsony

type ZuhyoClient* = ref object
  url*: string

type
  Variables* = Table[string, string]
  Query* = object
    query*: string
    variables*: Variables

template vars*[A, B](ctx: openArray[(A, B)]): Variables = 
  ## Converts a table into the Variables type
  toTable(ctx)

proc dumpHook*(s: var string, v: Variables) = s.add $v

proc newClient*(url: string): ZuhyoClient =
  ## Create a new zuhyo client
  return ZuhyoClient(url: url)

proc readQuery*(filename: string, v: Variables): Query =
  ## Read a graphql query from `filename` and use the variables `v`
  return Query(
    query: readFile filename,
    variables: v  
  )

proc newQuery*(body: string, v: Variables): Query =
  ## Create a query from `body` using variables `v`
  return Query(
    query: body,
    variables: v
  )

proc request*(api: ZuhyoClient, query: Query): Response =
  ## Request a response from the api provided in `ZuhyoClient` using the `query`
  return post(
    api.url,
    @[("Content-Type", "application/json")],
    toJson(query)
  )