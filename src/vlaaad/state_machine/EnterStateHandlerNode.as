/**
 * Author: Vlaaad
 * Date: 30.06.12
 */
package vlaaad.state_machine {
import vlaaad.state_machine.interfaces.IEnterStateHandler;

internal class EnterStateHandlerNode {

	internal var next:EnterStateHandlerNode;
	internal var prev:EnterStateHandlerNode;

	internal var handler:IEnterStateHandler;

	public function EnterStateHandlerNode(handler:IEnterStateHandler) {
		this.handler = handler;
	}
}
}
