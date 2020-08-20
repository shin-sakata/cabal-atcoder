module UserInterface.Cli.New (new) where

import Data.Text.IO as T
import Domain.Object.ContestId (ContestId (..))
import qualified Effect.Adapter.AtCoder as AtCoder
import qualified Effect.Adapter.Project as Project
import qualified Effect.Adapter.RIO as RIO
import qualified Effect.Handler.AtCoder.Http as HttpAtCoder
-- import qualified Effect.Handler.Project.File as FileProject
import Essential
import Usecase.CreateProject (createProject)
import qualified Usecase.Login as Usecase

new :: Text -> RIO env ()
new textContestId = runCreateProject $ createProject (ContestId textContestId)

runCreateProject :: Eff '[AtCoder.NamedEff, Project.NamedEff, RIO.NamedEff env] a -> RIO env a
runCreateProject = undefined

-- runCreateProject = retractEff . FileProject.run . HttpAtCoder.run mempty
