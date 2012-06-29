/**
 * Author: Vlaaad
 * Date: 30.06.12
 */
package vlaaad.state_machine {
internal class Transition {

	internal var from:State;
	internal var to:State;

	public function Transition(from:State, to:State) {
		this.from = from;
		this.to = to;
	}

	public function destroy():void {
		from.reset();
		to.reset();
		from = null;
		to = null;
	}
}
}
