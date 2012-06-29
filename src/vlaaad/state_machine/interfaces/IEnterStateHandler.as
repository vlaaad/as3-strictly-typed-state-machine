/**
 * Author: Vlaaad
 * Date: 30.06.12
 */
package vlaaad.state_machine.interfaces {
import vlaaad.state_machine.*;

public interface IEnterStateHandler {
	function onEnterState(state:State):void;
}
}
