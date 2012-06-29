/**
 * Author: Vlaaad
 * Date: 30.06.12
 */
package vlaaad.state_machine {
public class StateMachine {
	private var _isFinal:Boolean = false;
	private var _currentState:State;

	private const _transitions:Vector.<Transition> = new Vector.<Transition>();

	public function StateMachine(initialState:State) {
		nullCheck(initialState);
		_currentState = initialState;
	}

	public function allowTransition(from:State, to:State):void {
		finalCheck(_isFinal);
		nullCheck(from);
		nullCheck(to);
		for each (var transition:Transition in _transitions) {
			if (transition.from == from && transition.to == to) return;
		}
		_transitions.push(new Transition(from, to));
	}

	public function disallowTransition(from:State, to:State):void {
		finalCheck(_isFinal);
		nullCheck(from);
		nullCheck(to);
		const length:uint = _transitions.length;
		for (var i:int = 0; i < length; i++) {
			var transition:Transition = _transitions[i];
			if (transition.from == from && transition.to == transition.to) {
				_transitions.splice(i, 1);
				return;
			}
		}
	}

	public function makeFinal(finalizeStates:Boolean = false):void {
		_isFinal = true;
		if (!finalizeStates)return;
		for each(var transition:Transition in _transitions) {
			transition.from.makeFinal();
			transition.to.makeFinal();
		}
	}

	public function destroy():void {
		_isFinal = false;
		while (_transitions.length) {
			_transitions.shift().destroy();
		}
	}

	public function get currentState():State {
		return _currentState;
	}

	public function switchStateTo(newState:State):void {
		nullCheck(newState);
		for each(var transition:Transition in _transitions) {
			if (transition.from == _currentState && transition.to == newState) {
				transition.from.onExitState();
				_currentState = newState;
				transition.to.onEnterState();
				return;
			}
		}
	}

	internal static function finalCheck(value:Boolean):void {
		if (value) throw new Error("Can\'t modify immutable state machine!");
	}

	internal static function nullCheck(value:Object):void {
		if (!value) throw new Error("Null reference found!");
	}
}
}
