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

	/**
	 * Allow switching from one state to another
	 * @param from initial state
	 * @param to new state
	 */
	public function allowTransition(from:State, to:State):void {
		finalCheck(_isFinal);
		nullCheck(from);
		nullCheck(to);
		for each (var transition:Transition in _transitions) {
			if (transition.from == from && transition.to == to) return;
		}
		_transitions.push(new Transition(from, to));
	}

	/**
	 * Disallow transition from one state to another (makes sense only if this transition already exists — no states
	 * switching is allowed by default)
	 * @param from initial state
	 * @param to new state
	 */
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

	/**
	 * Restricts adding\removing transitions to state machine (raises error on attempt).
	 * @param finalizeStates optional parameter, if true, restricts adding\removing state
	 * handlers to state machine's states
	 */
	public function makeFinal(finalizeStates:Boolean = false):void {
		_isFinal = true;
		if (!finalizeStates) return;
		for each(var transition:Transition in _transitions) {
			transition.from.makeFinal();
			transition.to.makeFinal();
		}
	}

	/**
	 * Removes all transitions and resets all states (make them non final if they were final and removes all listeners)
	 */
	public function destroy():void {
		_isFinal = false;
		while (_transitions.length) {
			_transitions.shift().destroy();
		}
		_currentState = null;
	}

	public function get currentState():State {
		return _currentState;
	}

	/**
	 * Switches state to passed, if transition between states is allowed (see allowTransition)
	 * @param newState
	 */
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
