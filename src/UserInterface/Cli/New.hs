module UserInterface.Cli.New (new) where

import Data.Text.IO as T
import DomainObject.Contest (ContestId (..))
import qualified Effect.Adapter.AtCoder as AtCoder
import qualified Effect.Adapter.IO as IO
import qualified Effect.Adapter.Project as Project
import qualified Effect.Handler.AtCoder.Http as HttpAtCoder
import qualified Effect.Handler.Project.File as FileProject
import Essential
import Usecase.CreateProject (createProject)
import qualified Usecase.Login as Usecase

new :: Text -> IO ()
new textContestId = runCreateProject $ createProject (ContestId textContestId)

runCreateProject :: Eff '[AtCoder.NamedEff, Project.NamedEff, IO.NamedEff] a -> IO a
runCreateProject = retractEff . FileProject.run . HttpAtCoder.run mempty
