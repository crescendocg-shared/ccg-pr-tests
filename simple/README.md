# client/pinerest/scenario/simple

## You Are Here

This folder contains several simple tests in [json5 format](https://spec.json5.org). I choose json5 over vanilla json because it was easier to create
test cases and examples directly in a text editor. And it allowed for comments. Use a json5->json converter, for example node's [json5](https://www.npmjs.com/package/json5), to generate 
suitable input for the bhai service's payload. You can also author test cases in [json](https://www.json.org/json-en.htm) directly. Direct json is a little less convenient in a text editor
but more convenient with a supporting tool like [postman](https://learning.postman.com/docs/getting-started/introduction/).


## Mechanics

See the bash script `json5.sh` at the root of this project for a way to generate all the json from all the json5 in this project:

```bash
$ ./json5.sh #|> generated/json/*.json5.json
$ cat ./generated/json/algorith-test-row7.request.json5.json # note two file extension, .json5.json, to indicate that the json came from json5
{
  "format": {
    "request": "pinerest.org+flat",
    "response": "pinerest.org+flat"
  },
  "id": "b36cbb4a-5538-4f9f-aadd-74ca9fc0257d",
  "organization": "pinerest.org",
  "runDate": "2019-11-22T07:21-05:00",
  "hpiType": "P",
  "patientMRN": "435002",
  "patientBirthdate": "1996-01-01",
  "patientRace": "white",
  "patientGender": "male",
  "newToUnit": "0",
  "fallRisk": "false",
  "encounterDiagnosis": "F05",
  "encounterComorbidity": "R69",
  "wishToBeDead": "true",
  "suicidalThoughts": "false",
  "suicidalIdeationWithoutIntent": "true",
  "suicidalIdeationIntent": "true",
  "suicidalIdeationPlan": "false",
  "preparatoryActs": "false",
  "abortedAttempt": "false",
  "interruptedAttempt": "true",
  "actualAttempt": "false",
  "mhVisits": 0,
  "erVisits": 0,
  "aodVisits": 0,
  "medicalVisits": 2,
  "phq9FirstScore": 5,
  "phq9RecentScore": 7,
  "currentIntervention": "minimal",
  "futureIntervention": "minimal"
}
```

<a "#lore">
## Lore
</a>

Json5 comments are used to describe the fields and field values, termed "pairs". For example, in the json5 object:

```json5
{
    left: "right", // required caseful string "right"
}
```
there is one "pair": `left: "right"` annotated by one comment to the pair's right. The pair's key is `left` in json5, and "left" in json.
The pair's value is "right", which is a string. The comment indicates that this pair is "required" in the object and that the consumer of the
object considers case relevant. This means "right" is different from "Right" is different from "RIGHT". Comments are allowed in json5 and disallowed
in json. Converted json5 will remove all the (useful) comments.

The terms _json/json5 object_, _payload_ and _request_ are all used interchangably since the bhai service is expecting as input a single json object as the service "payload"
which is a _request_ to do something.

For the bhai service:

* All field values default to null if not present.

* The field's value type will be stated as: string, boolean, number, object or array. The bhai service uses all json field types.

* In certain cases (usually string), the type will be "narrowed" with additional qualifiers, e.g. "datestamp" or "timestamp" (see below).
  Json doesn't support a date object. And some clients can't generate json objects to represent "richer" values like dates. So the bhai
  service "parses the object" out of the string value. This allows clients (service callers) some flexibility in crafting their requests,
  especially for legacy systems. Unfortunately, these narrowed values can only be checked at runtime.

* String values can be "caseless" where case doesn't matter, or "caseful" where case does. 
  In general, case matters for labels, designators and ids. Where strings stand in for states or enumerations
  case doesn't matter. For example, gender can be stated as "m", "M", "male", "MALE" and even "1" for a male. 
  Case doesn't matter.
    
* For some fields, string can have a "truthy" interpretation similar to javascript https://developer.mozilla.org/en-US/docs/Glossary/Truthy.
  Specifically, if the string is: `null || "" => false` (read as "if the string value is null or the empty string, consider it boolean false)
  If the upper case value of the first letter is: `"0" || "N" || "F" || "n" || "f" => false`; all other string values => true.
  Note that this applies for strings only, unlike in javascript (which applies to booleans, numbers, objects and lists) and only for those
  fields that explicitly overload a string with "truthy" semantics.

* Some payload pairs are required. They're specified as such. Although required, the bhai endpoint
  will try to synthesize reasonable defaults and compute a score in their absense. The response will contain warnings however.
  But the computed score may not be what you expect. The service can guess wrong on your input. You shouldn't rely
  on a permissive service to accept your misformed input.

* Dates and times are encoded as strings formatted according to the [iso8601](https://www.iso.org/iso-8601-date-and-time-format.html) standard. This is also
  the [W3 format](https://www.w3.org/TR/NOTE-datetime) format with the proviso that years are always YYYY (four digits).
  This means the field value's JSON type is string. The bhai converts that string into an iso8660 timestamp object and will
  raise an error if the string can't be converted.
