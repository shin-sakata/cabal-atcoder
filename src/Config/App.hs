module Config.App where

import qualified Effect.Handler.Project.File.Config as ProjectFile
import qualified Effect.Handler.SessionRepository.File.Config as SessionFile
import Essential

data App = App
  { appLogFunc :: !LogFunc,
    sessionFileConfig :: !SessionFile.Config,
    projectFileConfig :: !ProjectFile.Config
  }

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x {appLogFunc = y})

-- SessionFileConfig settings

class HasSessionFileConfig env where
  sessionFileConfigL :: Lens' env SessionFile.Config

instance HasSessionFileConfig App where
  sessionFileConfigL = lens sessionFileConfig (\x y -> x {sessionFileConfig = y})

instance SessionFile.HasSessionPath App where
  sessionPathL = sessionFileConfigL . SessionFile.sessionPathL

-- ProjectFileConfig settings

class HasProjectFileConfig env where
  projectFileConfigL :: Lens' env ProjectFile.Config

instance HasProjectFileConfig App where
  projectFileConfigL = lens projectFileConfig (\x y -> x {projectFileConfig = y})

instance ProjectFile.HasProjectTemplate App where
  projectTemplateL = projectFileConfigL . ProjectFile.projectTemplateL

instance ProjectFile.HasTaskTemplate App where
  taskTemplateL = projectFileConfigL . ProjectFile.taskTemplateL

runApp :: RIO App a -> IO a
runApp exe = do
  logOptions' <- logOptionsHandle stderr False
  let logOptions = setLogUseTime True $ setLogUseLoc True logOptions'
  withLogFunc logOptions $ \logFunc -> do
    sessionFileConfig <- SessionFile.getConfig
    projectFileConfig <- ProjectFile.getConfig
    let app =
          App
            { appLogFunc = logFunc,
              sessionFileConfig = sessionFileConfig,
              projectFileConfig = projectFileConfig
            }
    runRIO app exe
