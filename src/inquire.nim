import puppy, tables, jsony

type InquireClient* = ref object
  url*: string

type
  Variables* = Table[string, string]
  Query* = object
    query*: string
    variables*: Variables

template vars*[A, B](ctx: openArray[(A, B)]): Variables = toTable(ctx)
proc dumpHook*(s: var string, v: Variables) = s.add $v

proc newClient*(url: string): InquireClient =
  return InquireClient(url: url)

proc readQuery*(filename: string, v: Variables): Query =
  return Query(
    query: readFile filename,
    variables: v  
  )

proc newQuery*(body: string, v: Variables): Query =
  return Query(
    query: body,
    variables: v
  )

proc request*(api: InquireClient, query: Query): Response =
  return post(
    api.url,
    @[("Content-Type", "application/json")],
    toJson(query)
  )