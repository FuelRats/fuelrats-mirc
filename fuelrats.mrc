menu nicklist {
  FuelRats
  .On emergency O2?: msg $chan $1 $+ : Are you on emergency oxygen? (Is there a blue timer in the top-right of your screen?)
  .PC or Xbox?: msg $chan $1 $+ : Are you on PC or Xbox?
  .System?: msg $chan $1 $+ : What system are you in?
  . -
  .$iif(%fr_client == $1,$style(1)) Set as client
  ..$iif(%fr_client == $1 && %fr_client_os == pc,$style(3)) PC: set_client_and_os $1 pc
  ..$iif(%fr_client == $1 && %fr_client_os == x,$style(3)) Xbox: set_client_and_os $1 x
  .$iif(%fr_dispatch == $1, $style(1)) Set as dispatch: {
    set %fr_dispatch $1
    echo -a Dispatch set to $1
  }
  . -
  .Assign to %fr_client : msg $chan !assign %fr_client $1-
  .Grab last message: msg $chan !grab $1
  . -
  .Ratsignal!: msg $chan !inject ratsignal $1
}

alias set_client_and_os {
  set %fr_client $1
  set %fr_client_os $2
  echo -a Client set to %fr_client %fr_client_os
}

menu channel {
  %fr_client
  .Prep: msg $chan !prep %fr_client
  .Send Friend Request: msg $chan ! $+ %fr_client_os $+ fr %fr_client
  .Send Wing Request: msg $chan ! $+ %fr_client_os $+ wing %fr_client
  .Enable Beacon: msg $chan ! $+ %fr_client_os $+ beacon %fr_client
  . -
  .$iif(%fr_client == null, $style(2)) Unset client: {
    unset %fr_client
    echo -a Client cleared
  }

  %fr_dispatch
  .Received Friend Request: msg $chan %fr_dispatch $+ : Friend request received from %fr_client
  .No Friend Request: msg $chan %fr_dispatch $+ : No friend request from %fr_client
  . -
  .Received Wing Request: msg $chan %fr_dispatch $+ : Wing request received from %fr_client
  .No Wing Request: msg $chan %fr_dispatch $+ : No wing request from %fr_client
  . -
  .Refueling %fr_client : msg $chan %fr_dispatch $+ : Refueling %fr_client
  .Paperwork filed: msg $chan %fr_dispatch $+ : %fr_client paperwork filed
  . -
  .Unset dispatch: {
    unset %fr_dispatch
    echo -a Dispatch unset
  }
  -
  Case Red
  .Tell dispatch: msg $chan %fr_dispatch $+ : %fr_client is now CR!
  .And tell client to quit: {
    msg $chan %fr_dispatch $+ : %fr_client is now CR!
    msg $chan ! $+ %fr_client_os $+ exit %fr_client
  }
  ..Tell mechasqueek: msg $chan !inject %fr_client Case Red
  -
  mechasqueak[BOT]
  .List Cases: msg $chan !list
  .List Inactive: msg $chan !list -i
  .Get info for
  ..0: msg $chan !quote 0
  ..1: msg $chan !quote 1
  ..2: msg $chan !quote 2
  ..3: msg $chan !quote 3
  ..4: msg $chan !quote 4
  .Close case
  ..0: msg $chan !clear 0
  ..1: msg $chan !clear 1
  ..2: msg $chan !clear 2
  ..3: msg $chan !clear 3
  ..4: msg $chan !clear 4
  .Current Case ( $+ %fr_client $+ )
  ..Toggle active: msg $chan !active %fr_client
  ..Quote: msg $chan !quote %fr_client
  ..Close: msg $chan !clear %fr_client
}

on *:NICK: {
  if ($nick === %fr_client) {
    set %fr_client $newnick
    echo -a Changed current client nick to $newnick
  }
  if ($nick === %fr_dispatch) {
    set %fr_dispatch $newnick
    echo -a Changed dispatch nick to $newnick
  }
}
