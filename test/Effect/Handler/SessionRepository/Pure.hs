module Effect.Handler.SessionRepository.Pure (run) where

import Effect.Adapter.SessionRepository (SessionRepository (..))
import Essential
import qualified Effect.Adapter.SessionRepository as SessionRepository

run ::
  forall effs a.
  Eff (SessionRepository.NamedEff ': effs) a ->
  Eff effs a
run effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. SessionRepository.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret Remove k = do
      k ()
    interpret Get k = do
      k mempty
    interpret (Store session) k = do
      k ()
