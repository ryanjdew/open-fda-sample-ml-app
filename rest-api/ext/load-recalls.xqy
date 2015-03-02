xquery version "1.0-ml";

module namespace ext = "http://marklogic.com/rest-api/resource/load-recalls";

import module namespace tb="ns://blakeley.com/taskbot"
  at "/lib/taskbot/src/taskbot.xqy" ;

declare namespace rapi   = "http://marklogic.com/rest-api";
declare namespace roxy = "http://marklogic.com/roxy";

declare namespace xhtml="http://www.w3.org/1999/xhtml";

declare namespace s="http://www.w3.org/2005/xpath-functions";

declare variable $MONTHS :=
  map:new((
    map:entry("January", "01"),
    map:entry("February", "02"),
    map:entry("March", "03"),
    map:entry("April", "04"),
    map:entry("May", "05"),
    map:entry("June", "06"),
    map:entry("July", "07"),
    map:entry("August", "08"),
    map:entry("September", "09"),
    map:entry("October", "10"),
    map:entry("November", "11"),
    map:entry("December", "12")));

declare variable $HTTP-OPTIONS :=
  <options xmlns="xdmp:http">
     <timeout>3600</timeout>
  </options>;

declare variable $SPAWN-OPTIONS :=
  <options xmlns="xdmp:eval">
    <transaction-mode>query</transaction-mode>
  </options>;

declare variable $SPAWN-OPTIONS-UPDATE :=
  <options xmlns="xdmp:eval">
    <transaction-mode>update</transaction-mode>
  </options>;

declare variable $STATES :=
  <states>
    <state code="AL" disp="Alabama" lat="32.3182314" lng="-86.9022980">alabama</state>
    <state code="AK" disp="Alaska" lat="64.2008413" lng="-149.4936733">alaska</state>
    <state code="AZ" disp="Arizona" lat="34.0489281" lng="-111.0937311">arizona</state>
    <state code="AR" disp="Arkansas" lat="35.2010500" lng="-91.8318334">arkansas</state>
    <state code="CA" disp="California" lat="36.7782610" lng="-119.4179324">california</state>
    <state code="CO" disp="Colorado" lat="39.5500507" lng="-105.7820674">colorado</state>
    <state code="CT" disp="Connecticut" lat="41.6032207" lng="-73.0877490">connecticut</state>
    <state code="DE" disp="Delaware" lat="38.9108325" lng="-75.5276699">delaware</state>
    <state code="DC" disp="District Of Columbia" lat="38.9059849" lng="-77.0334179">district of columbia</state>
    <state code="FL" disp="Florida" lat="27.6648274" lng="-81.5157535">florida</state>
    <state code="GA" disp="Georgia" lat="32.1656221" lng="-82.9000751">georgia</state>
    <state code="HI" disp="Hawaii" lat="19.8967662" lng="-155.5827818">hawaii</state>
    <state code="ID" disp="Idaho" lat="44.0682019" lng="-114.7420408">idaho</state>
    <state code="IL" disp="Illinois" lat="40.6331249" lng="-89.3985283">illinois</state>
    <state code="IN" disp="Indiana" lat="40.2671941" lng="-86.1349019">indiana</state>
    <state code="IA" disp="Iowa" lat="41.8780025" lng="-93.0977020">iowa</state>
    <state code="KS" disp="Kansas" lat="39.0119020" lng="-98.4842465">kansas</state>
    <state code="KY" disp="Kentucky" lat="37.8393332" lng="-84.2700179">kentucky</state>
    <state code="LA" disp="Louisiana" lat="30.9842977" lng="-91.9623327">louisiana</state>
    <state code="ME" disp="Maine" lat="45.2537830" lng="-69.4454689">maine</state>
    <state code="MD" disp="Maryland" lat="39.0457549" lng="-76.6412712">maryland</state>
    <state code="MA" disp="Massachusetts" lat="42.4072107" lng="-71.3824374">massachusetts</state>
    <state code="MI" disp="Michigan" lat="44.3148443" lng="-85.6023643">michigan</state>
    <state code="MN" disp="Minnesota" lat="46.7295530" lng="-94.6858998">minnesota</state>
    <state code="MS" disp="Mississippi" lat="32.3546679" lng="-89.3985283">mississippi</state>
    <state code="MO" disp="Missouri" lat="37.9642529" lng="-91.8318334">missouri</state>
    <state code="MT" disp="Montana" lat="46.8796822" lng="-110.3625658">montana</state>
    <state code="NE" disp="Nebraska" lat="41.4925374" lng="-99.9018131">nebraska</state>
    <state code="NV" disp="Nevada" lat="38.8026097" lng="-116.4193890">nevada</state>
    <state code="NH" disp="New Hampshire" lat="43.1938516" lng="-71.5723953">new hampshire</state>
    <state code="NJ" disp="New Jersey" lat="40.0583238" lng="-74.4056612">new jersey</state>
    <state code="NM" disp="New Mexico" lat="34.5199402" lng="-105.8700901">new mexico</state>
    <state code="NY" disp="New York" lat="43.2994285" lng="-74.2179326">new york</state>
    <state code="NC" disp="North Carolina" lat="35.7595731" lng="-79.0192997">north carolina</state>
    <state code="ND" disp="North Dakota" lat="47.5514926" lng="-101.0020119">north dakota</state>
    <state code="OH" disp="Ohio" lat="40.4172871" lng="-82.9071230">ohio</state>
    <state code="OK" disp="Oklahoma" lat="35.0077519" lng="-97.0928770">oklahoma</state>
    <state code="OR" disp="Oregon" lat="43.8041334" lng="-120.5542012">oregon</state>
    <state code="PA" disp="Pennsylvania" lat="41.2033216" lng="-77.1945247">pennsylvania</state>
    <state code="RI" disp="Rhode Island" lat="41.5800945" lng="-71.4774291">rhode island</state>
    <state code="SC" disp="South Carolina" lat="33.8360810" lng="-81.1637245">south carolina</state>
    <state code="SD" disp="South Dakota" lat="43.9695148" lng="-99.9018131">south dakota</state>
    <state code="TN" disp="Tennessee" lat="35.5174913" lng="-86.5804473">tennessee</state>
    <state code="TX" disp="Texas" lat="31.9685988" lng="-99.9018131">texas</state>
    <state code="UT" disp="Utah" lat="39.3209801" lng="-111.0937311">utah</state>
    <state code="VT" disp="Vermont" lat="44.5588028" lng="-72.5778415">vermont</state>
    <state code="VA" disp="Virginia" lat="37.4315734" lng="-78.6568942">virginia</state>
    <state code="WA" disp="Washington" lat="47.7510741" lng="-120.7401386">washington</state>
    <state code="WV" disp="West Virginia" lat="38.5976262" lng="-80.4549026">west virginia</state>
    <state code="WI" disp="Wisconsin" lat="43.7844397" lng="-88.7878678">wisconsin</state>
    <state code="WY" disp="Wyoming" lat="43.0759678" lng="-107.2902839">wyoming</state>
  </states>;

declare variable $date-names := fn:tokenize("recall_initiation_date report_date","\s+");

declare variable $page-size := 75;

declare function ext:add-recalls($year, $page as xs:integer) {
  xdmp:log("loading year: " || $year || " and page: "|| $page),
  let $response := xdmp:http-get(
       "https://api.fda.gov/food/enforcement.json?api_key=0MFXY5cHDk3cVyj4bsQryur4eOIafqby9SSjFNH6&amp;search=report_date:["||$year||"0101+TO+"||$year||"1231]&amp;limit="||$page-size||"&amp;skip="||($page*$page-size),
       <options xmlns="xdmp:http"><verify-cert>false</verify-cert></options>
     )[2]
  for $recall in $response/results
  let $recall-number as xs:string :=  $recall/recall_number
  where fn:not(xdmp:exists(cts:search(/recall,cts:element-value-query(xs:QName('recall_number'),$recall-number,'exact'))))
  return (
    let $recall-xml := ext:transform($recall)
    let $recall-uri as xs:string := "/recalls/"||$recall-number||".xml"
    return
      xdmp:document-insert($recall-uri,$recall-xml, xdmp:permission("fda-recall-search-role","read"))
  )
};

declare function ext:transform($result) {
  element recall {
    ext:process($result)
  }
};

declare function ext:process($item as item()) {
  typeswitch($item)
  case object-node() return
    for $prop in $item/*
    let $key := fn:replace(fn:string(fn:node-name($prop)),"@", '')
    let $value := $prop
    where $key
    return
      if ($value instance of array-node())
      then
        (: if it is an array add plural wrapper :)
        element {$key||'s'} {
          for $val in $value
          return
            element {$key} {ext:process($val)}
        }
      else
        element {$key} {
          if ($key = "distribution_pattern") then
            ext:find-states($prop)/*
          else if ($key = $date-names)
          then
            (: if it is a date, make sure it is in the correct format :)
            let $val := ext:process($value)
            return
              if (fn:matches($val,"^([0-9]{4,4})([0-9]{2,2})([0-9]{2,2})$"))
              then
                fn:replace($val,"^([0-9]{4,4})([0-9]{2,2})([0-9]{2,2})$","$1-$2-$3")
              else if (fn:matches($val,"^([0-9]{4,4})([0-9]{2,2})$"))
              then
                fn:replace($val,"^([0-9]{4,4})([0-9]{2,2})$","$1-$2-01")
              else if (fn:matches($val,"^([0-9]{4,4})$"))
              then
                fn:replace($val,"^([0-9]{4,4})$","$1-01-01")
              else
                $val
          else
            ext:process($value)
        }
  default return fn:data($item)
};


declare %private function ext:find-states($txt as node())
as element(states)
{
  <states>
  {
    let $states :=
      if (fn:matches(fn:lower-case($txt), "nationwide")) then
        $STATES/state ! element distribution_state
            {
              (: inserted documents for each of the states instead that have lat/lng :)
              ./@lat,
              ./@lng,
              ./@disp/fn:string()
            }
      else
        (for $s in fn:distinct-values(
            cts:walk(
              element text {$txt},
              cts:or-query(
                ($STATES/state/(fn:string(), @code/fn:string())) ! cts:word-query(.)
              ),
              (: deal with overlap as per
                https://help.marklogic.com/Knowledgebase/Article/View/132/0/ctshighlight-with-overlapping-matches :)
              if (fn:count($cts:queries) gt 1)
              then
                xdmp:set($cts:action, "continue")
              else
                (: I would have thought that $cts:text would have given me what I wanted,
                  but settling for query text instead :)
                cts:word-query-text($cts:queries)
            )
          )
        let $state :=
          if (fn:string-length($s) = 2) then
            ($STATES/state[@code=$s])[1]
          else
            let $s := fn:lower-case($s)
            return
              ($STATES/state[.=$s])[1]
        return
          if ($state) then
            element distribution_state
            {
              (: inserted documents for each of the states instead that have lat/lng :)
              $state/@lat,
              $state/@lng,
              $state/@disp/fn:string()
            }
          else
          (
            xdmp:log("can't find state: " || $s),
            xdmp:log($txt)
          )
        )
    let $states := $states[
        fn:position() = fn:index-of($states,.)[1]
      ]
    return (
      if (fn:count($states) eq fn:count($STATES/*)) then
        element distribution_state {"Nationwide"}
      else (),
      $states
    )
  }
  </states>
};


declare %private function ext:load-recalls
(
  $year as xs:int)
{
  xdmp:log("loading year: " || $year ),
  let $size := ext:get-size-for-year($year)
  return
    tb:list-segment-process(
      (: Total size of the job. :)
      (0 to ($size idiv $page-size)),
      (: Size of each segment of work. :)
      5,
      "load/recalls",
      (: This anonymous function will be called for each segment. :)
      function($list as item()+, $opts as map:map?) {
        (: Any chainsaw should have a safety. Check it here. :)
        tb:maybe-fatal(),
        for $page in $list
        let $_ := xdmp:sleep(250)
        return ext:add-recalls($year,$page),
        (: This is an update, so be sure to commit each segment. :)
        xdmp:commit() },
      (: options - not used in this example. :)
      (),
      (: This is an update, so be sure to say so. :)
      $tb:OPTIONS-UPDATE)
};

declare function ext:get-size-for-year($year) as xs:integer {
   let $response := xdmp:http-get(
        "https://api.fda.gov/food/enforcement.json?api_key=0MFXY5cHDk3cVyj4bsQryur4eOIafqby9SSjFNH6&amp;search=report_date:["||$year||"0101+TO+"||$year||"1231]&amp;limit=1",
        <options xmlns="xdmp:http"><verify-cert>false</verify-cert></options>
      )[2]
   let $_ := xdmp:log(xdmp:describe($response,(),()))
   return ($response/meta/results/total,0)[1]
};

declare
%rapi:transaction-mode("update")
function ext:get(
  $context as map:map,
  $params  as map:map
) as document-node()*
{
  xdmp:log('request load-recalls made'),
  map:put($context, "output-types", "text/plain"),
  for $year in (2015 to 2015)
  return
    ext:load-recalls($year),
  document { "loading recall data" }
};
