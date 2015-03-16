AS3 wrapper for Jayrock communication.

**Example:**

```
import be.wellconsidered.jayrock.events.JayrockEvent;
import be.wellconsidered.jayrock.Jayrock;

private function init():void
{
	var jrSearch:Jayrock = new Jayrock("http://XXX/XXX/wsSearch.ashx");
	
	jrSearch.addEventListener(JayrockEvent.COMPLETE, onResult, false, 0, true);
	jrSearch.addEventListener(JayrockEvent.ERROR, onError, false, 0, true);
	
	jrSearch.searchit({"TAG": "XXX"});
}

private function onResult(e:JayrockEvent):void
{
	for(var i:* in e.data)
	{
		trace(i + ": " + e.data[i]);
	}
}

private function onError(e:JayrockEvent):void
{
	trace(e.data);
}
```