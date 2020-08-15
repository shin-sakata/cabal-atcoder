module Effect.Handler.Project.File (run) where

import Data.Text.IO as T
import qualified Data.Text.Lazy as LT
import DomainObject.Contest (Contest (..))
import qualified DomainObject.Contest as Contest
import DomainObject.Contest.ContestId (ContestId (..))
import DomainObject.TaskId (TaskId (..))
import qualified Effect.Adapter.IO as IO
import Effect.Adapter.Project (Project (..))
import qualified Effect.Adapter.Project as Project
import Essential
import System.Directory
  ( XdgDirectory (XdgCache),
    createDirectory,
    doesDirectoryExist,
  )
import System.Environment (getEnv)
import System.FilePath ((</>))
import Text.Blaze (Markup)
import Text.Blaze.Renderer.Text (renderMarkup)
import Text.Heterocephalus (compileTextFile)
import Text.Read (readMaybe)

run ::
  forall effs a.
  IO.HasEff effs =>
  Eff (Project.NamedEff ': effs) a ->
  Eff effs a
run effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. Project.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret (CreateProject contest) k = do
      IO.lift $ createProject contest
      k ()

createProject :: Contest -> IO ()
createProject contest = do
  let contestId = Contest.id contest
  let tasks = Contest.tasks contest
  let projectDirectory = show contestId
  let projectCabal =
        renderText $(compileTextFile "src/Effect/Handler/Project/Templates/project.cabal.stub")

  createDirectory projectDirectory

  T.writeFile (projectDirectory </> show contestId <> ".cabal") projectCabal

  mapM_ (createTask projectDirectory) tasks
  where
    createTask :: FilePath -> TaskId -> IO ()
    createTask dir taskId = do
      let taskFile =
            renderText $(compileTextFile "src/Effect/Handler/Project/Templates/task.hs.stub")
      T.writeFile (dir </> (show taskId <> ".hs")) taskFile

    renderText :: Markup -> Text
    renderText = convertString . renderMarkup
