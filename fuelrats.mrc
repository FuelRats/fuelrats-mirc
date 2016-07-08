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
  .Ratsignal!: msg $chan !inject $1 ratsignal %fr_client_os
}

alias set_client_and_os {
  set %fr_client $1
  set %fr_client_os $2
  echo -a Client set to %fr_client %fr_client_os
}

menu channel {
  %fr_client
  .KgbFoam: msg $chan !kgbfoam %fr_client
  .-
  .Prep: msg $chan !prep %fr_client
  .Send Friend Request: msg $chan ! $+ %fr_client_os $+ fr %fr_client
  .Send Wing Request: msg $chan ! $+ %fr_client_os $+ wing %fr_client
  .Enable Beacon: msg $chan ! $+ %fr_client_os $+ beacon %fr_client
  .-
  .$iif(%fr_client == null, $style(2)) Unset client: {
    unset %fr_client
    echo -a Client cleared
  }

  %fr_dispatch
  .Roger: msg $chan Roger that %fr_dispatch
  .Ready: msg $chan Ready %fr_dispatch
  .On my way: msg $chan %fr_dispatch $+ : On my way to %fr_client
  .+System+: msg $chan %fr_dispatch $+ : sys+ %fr_client
  .-
  .+Recieved Friend Request+: msg $chan %fr_dispatch $+ : fr+ %fr_client
  .-No Friend Request-: msg $chan %fr_dispatch $+ : fr- %fr_client
  . -
  .+Recieved Wing Request+: msg $chan %fr_dispatch $+ : wr+ %fr_client
  .-No Wing Request-: msg $chan %fr_dispatch $+ : wr- %fr_client
  . -
  .+Beacon in place+: msg $chan %fr_dispatch $+ : bc+ %fr_client
  .-No Beacon-: msg $chan %fr_dispatch $+ : bc- %fr_client
  .-
  .+Position+: msg $chan %fr_dispatch $+ : pos+ %fr_client
  .-No Instance-: msg $chan %fr_dispatch $+ : intance- %fr_client
  .-
  .Refueling %fr_client : msg $chan %fr_dispatch $+ : Refueling %fr_client
  .db+pw+ %fr_client: msg $chan %fr_dispatch $+ : db+pw+ %fr_client
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
  ..Tell RatSqueak: msg $chan !codered %fr_client Case Red
  -
  RatSqueak[BOT]
  .%fr_client
  ..Toggle active: msg $chan !active %fr_client
  ..Quote: msg $chan !quote %fr_client
  ..Close: msg $chan !clear %fr_client
  .-
  .List Cases: msg $chan !list
  .List Inactive: msg $chan !list -i
  .Get info for
  ..$submenu($case_info_menu($1))
  .Close case
  ..$submenu($case_close_menu($1))
}

menu query {
  %fr_client
  . -
  .$iif(%fr_client == null, $style(2)) Unset client: {
    unset %fr_client
    echo -a Client cleared
  }

  %fr_dispatch
  . -
  .Unset dispatch: {
    unset %fr_dispatch
    echo -a Dispatch unset
  }
  -
  Case Red
  ..Tell RatSqueak: query RatSqueak[BOT] !codered %fr_client Case Red
  -
  RatSqueak[BOT]
  .%fr_client
  ..Toggle active: query RatSqueak[BOT] !active %fr_client
  ..Quote: query RatSqueak[BOT] !quote %fr_client
  ..Close: query RatSqueak[BOT] !clear %fr_client
  .-
  .List Cases:query RatSqueak[BOT] !list
  .List Inactive: query RatSqueak[BOT] !list -i
  .Get info for
  ..$submenu($case_info_menuq($1))
  .Close case
  ..$submenu($case_close_menuq($1))
}

alias case_info_menu {
  if ($1 <= 10) return Case $calc($1 - 1) : msg $chan !quote $calc($1 - 1)
}

alias case_close_menu {
  if ($1 <= 10) return Case $calc($1 - 1) : msg $chan !clear $calc($1 - 1)
}

alias case_info_menuq {
  if ($1 <= 10) return Case $calc($1 - 1) : query RatSqueak[BOT] !quote $calc($1 - 1)
}

alias case_close_menuq {
  if ($1 <= 10) return Case $calc($1 - 1) : query RatSqueak[BOT] !clear $calc($1 - 1)
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
