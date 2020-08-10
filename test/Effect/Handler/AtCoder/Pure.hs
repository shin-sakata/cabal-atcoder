module Effect.Handler.AtCoder.Pure where

import Data.Extensible.Effect (Eff, peelEff0)
import Effect.Adapter.AtCoder (AtCoder (..))
import qualified Effect.Adapter.AtCoder as AtCoder
import Effect.Adapter.SessionRepository (Session)

run ::
  forall effs a.
  Session ->
  Eff (AtCoder.NamedEff ': effs) a ->
  Eff effs a
run initSession effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. AtCoder.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret (CreateSession userName userPassword) k = do
      k mempty
