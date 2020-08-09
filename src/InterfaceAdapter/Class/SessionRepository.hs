module InterfaceAdapter.Class.SessionRepository
  ( AnonEff,
    EffName,
    HasEff,
    NamedEff,
    lift,
    SessionRepository (..),
    get,
    remove,
    store,
    Session,
  )
where

import Data.Extensible
import Data.Extensible.Effect
import Data.Proxy (Proxy (Proxy))
import Essential hiding (lift)
import Network.HTTP.Client (CookieJar)

type Session = CookieJar

data SessionRepository a where
  Get :: SessionRepository Session
  Store :: Session -> SessionRepository ()
  Remove :: SessionRepository ()

type EffName = "SessionRepository"

type AnonEff = SessionRepository

type NamedEff = EffName >: AnonEff

type HasEff effs = Lookup effs EffName SessionRepository

lift :: forall effs a. HasEff effs => SessionRepository a -> Eff effs a
lift = liftEff (Proxy @EffName)

get :: HasEff effs => Eff effs (Session)
get = lift Get

store :: HasEff effs => Session -> Eff effs ()
store session = lift (Store session)

remove :: HasEff effs => Eff effs ()
remove = lift Remove
