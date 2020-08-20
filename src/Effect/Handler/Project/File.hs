module Effect.Handler.Project.File where

import Domain.Object.Contest (Contest)
import qualified Domain.Object.Project as Obj
import Effect.Adapter.IO as IO
import Effect.Adapter.Project (Project (..))
import qualified Effect.Adapter.Project as Project
import Essential

run ::
  forall effs a.
  IO.HasEff effs =>
  Eff (Project.NamedEff ': effs) a ->
  Eff effs a
run effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. Project.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret (BuildProject contest) k = do
      project <- IO.lift $ buildProject contest
      k project
    interpret (WriteProject project) k = do
      IO.lift $ writeProject project
      k ()

buildProject :: Contest -> IO Obj.Project
buildProject = undefined

writeProject :: Obj.Project -> IO ()
writeProject = undefined
