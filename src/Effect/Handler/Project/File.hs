module Effect.Handler.Project.File where

import Domain.Object.Contest (Contest)
import qualified Domain.Object.Project as Obj
import Effect.Adapter.Project (Project (..))
import qualified Effect.Adapter.Project as Project
import Effect.Adapter.RIO as RIO
import Essential

run ::
  forall env effs a.
  RIO.HasEff env effs =>
  Eff (Project.NamedEff ': effs) a ->
  Eff effs a
run effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. Project.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret (BuildProject contest) k = do
      project <- RIO.lift $ buildProject contest
      k project
    interpret (WriteProject project) k = do
      RIO.lift $ writeProject project
      k ()

buildProject :: Contest -> RIO env Obj.Project
buildProject = undefined

writeProject :: Obj.Project -> RIO env ()
writeProject = undefined
