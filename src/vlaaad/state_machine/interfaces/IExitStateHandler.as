/**
 * Author: Vlaaad
 * Date: 30.06.12
 */
package vlaaad.state_machine.interfaces {
import vlaaad.state_machine.*;

public interface IExitStateHandler {
	function onExitState(state:State):void;
}
}
