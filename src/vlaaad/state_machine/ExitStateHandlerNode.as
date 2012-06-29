/**
 * Author: Vlaaad
 * Date: 30.06.12
 */
package vlaaad.state_machine {
import vlaaad.state_machine.interfaces.IExitStateHandler;

internal class ExitStateHandlerNode {
	internal var next:ExitStateHandlerNode;
	internal var prev:ExitStateHandlerNode;

	internal var handler:IExitStateHandler;

	public function ExitStateHandlerNode(handler:IExitStateHandler) {
		this.handler = handler;
	}
}
}
