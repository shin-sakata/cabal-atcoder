module InterfaceAdapter.Class.AtCoder where

import DomainObject.TaskAnswer (TaskAnswer)
import DomainObject.UserName (UserName)
import DomainObject.UserPassword (UserPassword)
import InterfaceAdapter.Class.SessionManager (Session)

class AtCoder a where
  createSession :: UserName -> UserPassword -> a Session