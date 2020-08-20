module Config.App where

import qualified Effect.Handler.SessionRepository.File.Config as SessionFile
import Essential

data App = App
  { appLogFunc :: !LogFunc,
    sessionFileConfig :: !SessionFile.Config
  }

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x {appLogFunc = y})

class HasSessionFileConfig env where
  sessionFileConfigL :: Lens' env SessionFile.Config

instance HasSessionFileConfig App where
  sessionFileConfigL = lens sessionFileConfig (\x y -> x {sessionFileConfig = y})

instance SessionFile.HasSessionPath App where
  sessionPathL = sessionFileConfigL . SessionFile.sessionPathL

runApp :: RIO App a -> IO a
runApp exe = do
  sessionFileConfig <- SessionFile.getConfig
  logOptions' <- logOptionsHandle stderr False
  let logOptions = setLogUseTime True $ setLogUseLoc True logOptions'
  withLogFunc logOptions $ \logFunc -> do
    let app = App {appLogFunc = logFunc, sessionFileConfig = sessionFileConfig}
    runRIO app exe
