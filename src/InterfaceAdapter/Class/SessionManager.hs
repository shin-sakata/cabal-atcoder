module InterfaceAdapter.Class.SessionManager (Session, SessionManager (..)) where

import DomainObject.UserName (UserName)
import DomainObject.UserPassword (UserPassword)
import Network.HTTP.Client (CookieJar)

type Session = CookieJar

class SessionManager a where
  getSession :: a Session
  saveSession :: Session -> a ()
