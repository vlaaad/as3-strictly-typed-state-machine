/**
 * Author: Vlaaad
 * Date: 30.06.12
 */
package vlaaad.state_machine {
import vlaaad.state_machine.interfaces.IEnterStateHandler;
import vlaaad.state_machine.interfaces.IExitStateHandler;

public class State {

	private var _isFinal:Boolean = false;
	private var _enterHead:EnterStateHandlerNode;
	private var _exitHead:ExitStateHandlerNode;
	private var _name:String;

	public function State(name:String = null) {
		_name = name;
	}

	// ------------------ add handlers ------------------ //
	/**
	 * Adds callback, called when state machine enters this state
	 * @param handler
	 */
	public function addEnterStateHandler(handler:IEnterStateHandler):void {
		StateMachine.finalCheck(_isFinal);
		StateMachine.nullCheck(handler);
		if (hasEnterStateHandler(handler)) return;
		if (!_enterHead) {
			_enterHead = new EnterStateHandlerNode(handler);
		} else {
			var node:EnterStateHandlerNode = _enterHead;
			while (node.next) {
				node = node.next;
			}
			node.next = new EnterStateHandlerNode(handler);
			node.next.prev = node;
		}
	}

	/**
	 * Adds callback, called when state machine leaves this state
	 * @param handler
	 */
	public function addExitStateHandler(handler:IExitStateHandler):void {
		StateMachine.finalCheck(_isFinal);
		StateMachine.nullCheck(handler);
		if (hasExitStateHandler(handler)) return;
		if (!_exitHead) {
			_exitHead = new ExitStateHandlerNode(handler);
		} else {
			var node:ExitStateHandlerNode = _exitHead;
			while (node.next) {
				node = node.next;
			}
			node.next = new ExitStateHandlerNode(handler);
			node.next.prev = node;
		}
	}

	// ------------------ remove handlers ------------------ //

	/**
	 * Removes callback, called when state machine enters this state.
	 * @param handler
	 */
	public function removeEnterStateHandler(handler:IEnterStateHandler):void {
		StateMachine.finalCheck(_isFinal);
		StateMachine.nullCheck(handler);
		const node:EnterStateHandlerNode = getEnterStateHandlerNode(handler);
		if (!node) return;
		if (!node.prev) {
			_enterHead = node.next;
			node.next = null;
			node.handler = null;
		} else {
			node.prev.next = node.next;
			if (node.next) node.next.prev = node.prev;
			node.next = null;
			node.prev = null;
			node.handler = null;
		}
	}

	/**
	 * Removes callback, called when state machine leaves this state.
	 * @param handler
	 */
	public function removeExitStateHandler(handler:IExitStateHandler):void {
		StateMachine.finalCheck(_isFinal);
		StateMachine.nullCheck(handler);
		const node:ExitStateHandlerNode = getExitStateHandlerNode(handler);
		if (!node) return;
		if (!node.prev) {
			_exitHead = node.next;
			node.next = null;
			node.handler = null;
		} else {
			node.prev.next = node.next;
			if (node.next) node.next.prev = node.prev;
			node.next = null;
			node.prev = null;
			node.handler = null;
		}
	}

	// ------------------ check handlers ------------------ //

	public function hasEnterStateHandler(handler:IEnterStateHandler):Boolean {
		return getEnterStateHandlerNode(handler) != null;
	}

	public function hasExitStateHandler(handler:IExitStateHandler):Boolean {
		return getExitStateHandlerNode(handler) != null;
	}

	// ------------------ remove handlers ------------------ //

	public function removeAllEnterStateHandlers():void {
		StateMachine.finalCheck(_isFinal);
		var node:EnterStateHandlerNode = _enterHead;
		var same:EnterStateHandlerNode;
		while (node) {
			same = node;
			node = node.next;
			same.next = null;
			same.prev = null;
			same.handler = null;
		}
	}

	public function removeAllExitStateHandlers():void {
		StateMachine.finalCheck(_isFinal);
		var node:ExitStateHandlerNode = _exitHead;
		var same:ExitStateHandlerNode;
		while (node) {
			same = node;
			node = node.next;
			same.next = null;
			same.prev = null;
			same.handler = null;
		}
	}

	public function removeAllHandlers():void {
		StateMachine.finalCheck(_isFinal);
		removeAllEnterStateHandlers();
		removeAllExitStateHandlers();
	}

	/**
	 * restricts adding\removing handler for this state
	 */
	public function makeFinal():void {
		_isFinal = true;
	}

	// ------------------ switch state notifications ------------------ //

	internal function onEnterState():void {
		var node:EnterStateHandlerNode = _enterHead;
		while (node) {
			node.handler.onEnterState(this);
			node = node.next;
		}
	}

	internal function onExitState():void {
		var node:ExitStateHandlerNode = _exitHead;
		while (node) {
			node.handler.onExitState(this);
			node = node.next;
		}
	}

	// ------------------ reset ------------------ //

	internal function reset():void {
		_isFinal = false;
		removeAllHandlers();
	}

	// ------------------ get handlers ------------------ //

	private function getEnterStateHandlerNode(handler:IEnterStateHandler):EnterStateHandlerNode {
		var node:EnterStateHandlerNode = _enterHead;
		while (node) {
			if (node.handler == handler) return node;
			node = node.next;
		}
		return null;
	}

	private function getExitStateHandlerNode(handler:IExitStateHandler):ExitStateHandlerNode {
		var node:ExitStateHandlerNode = _exitHead;
		while (node) {
			if (node.handler == handler) return node;
			node = node.next;
		}
		return null;
	}

	/**
	 * returns string, passed to constructor
	 */
	public function get name():String {
		return _name;
	}
}
}
