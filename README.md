How to use it:


    const think:State = new State("think");
    const sleep:State = new State("sleep");
    const machine:StateMachine = new StateMachine(think);


So, now we have state machine with initial state == think.
We can do this:


    machine.switchStateTo(sleep);


But nothing will happen. Why? Because transition from state "think" to state "sleep" is not allowed yet.
So at first we allow this transition:


    machine.allowTransition(think, sleep);


Now, after calling "machine.switchStateTo(sleep);" again, current state of machine will be "sleep".
Sadly, now you will sleep forever, because there is no allowed transitions from sleep state yet.
But you now what to do with this.

Events like StateEvent.ENTER_STATE? No. Interfaces!
For any state you can add handlers this way:


    think.addEnterStateHandler(enterStateHandler);
    think.addExitStateHandler(exitStateHandler);


Your handlers must implement IEnterStateHandler or IExitStatehandler, this interfaces has only one function: "onEnterState(state:State):void" or "onExitState(state:State)".
So, no functions as arguments, only OOP, only hardcore!

After creating your state machine with needed states and transitions, you can restrict any modifications to this transitions by calling:

    machine.makeFinal();

After making state machine final, any attempts to add\remove transition to it will lead to throwing error.
Optionally, you can make final not only transitions, but also states used in this state machine (this will restrict adding\removing handlers).

After all, you can destroy state machine by calling:

    machine.destroy();

This will remove all machine's allowed transitions and all handlers from used states in this state machine. State machine will be unusable. Totally.

P.S. License: WTFPL.