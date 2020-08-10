module Effect.Adapter.AtCoder
  ( AnonEff,
    EffName,
    HasEff,
    NamedEff,
    lift,
    AtCoder (..),
    createSession,
    getContest,
  )
where

import Data.Extensible
import Data.Extensible.Effect
import Data.Proxy (Proxy (Proxy))
import DomainObject.Contest.ContestId (ContestId)
import DomainObject.Contest (Contest)
import DomainObject.UserName (UserName)
import DomainObject.UserPassword (UserPassword)
import Effect.Adapter.SessionRepository (Session)
import Essential hiding (lift)
import Network.HTTP.Client (CookieJar)

data AtCoder a where
  CreateSession :: UserName -> UserPassword -> AtCoder Session
  GetContest :: ContestId -> AtCoder Contest

type EffName = "AtCoder"

type AnonEff = AtCoder

type NamedEff = EffName >: AnonEff

type HasEff effs = Lookup effs EffName AtCoder

lift :: forall effs a. HasEff effs => AtCoder a -> Eff effs a
lift = liftEff (Proxy @EffName)

createSession :: HasEff effs => UserName -> UserPassword -> Eff effs Session
createSession userName userPassword = lift (CreateSession userName userPassword)

getContest :: HasEff effs => ContestId -> Eff effs Contest
getContest contestId = lift (GetContest contestId)
