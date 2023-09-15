# Zuhyo (図表)
The easiest way to interact with a graphql api

### Features
 - Fast as fuck
 - No need for openssl or other ssl libraries when compiling
## Installation

Zuhyo can be installed through nimble (coming soon)

```sh
nimble install zuhyo
```

or through git

```sh
nimble install https://github.com/arashi-software/zuhyo
```

## Usage

GraphQL query from a file

```nim
let 
  api = zuhyo.newClient("https://graphql.anilist.co") # Create a new zuhyo client; Pass in the api endpoint
  query = "tests/test.gql".readQuery(vars {"id": "15125"}) # Read a file to create a query and pass in variables using the vars function
  req = api.request(query) # Finally request from the api using the graphql query we just created

echo req.code # Response code of the request
echo req.headers # Headers returned in the request
echo req.body # Actual json
```

GraphQL query from text

```nim
let 
  api = zuhyo.newClient("https://graphql.anilist.co") # Create a new zuhyo client; Pass in the api endpoint
  query = """
query ($id: Int) { # Define which variables will be used in the query (id)
  Media (id: $id, type: ANIME) { # Insert our variables into the query arguments (id) (type: ANIME is hard-coded in the query)
    id
    title {
      romaji
      english
      native
    }
  }
}
""".newQuery(vars {"id": "15125"}) # Read a file to create a query and pass in variables using the vars function
  req = api.request(query) # Finally request from the api using the graphql query we just created

echo req.code # Response code of the request
echo req.headers # Headers returned in the request
echo req.body # Actual json
```