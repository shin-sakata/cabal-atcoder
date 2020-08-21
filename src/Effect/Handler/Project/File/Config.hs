module Effect.Handler.Project.File.Config where

import Essential
import RIO.Directory
  ( XdgDirectory (XdgCache),
    createDirectoryIfMissing,
    doesDirectoryExist,
    getXdgDirectory,
  )
import System.Environment (lookupEnv)

data Config = Config
  { projectTemplate :: !Text,
    taskTemplate :: !Text
  }

class HasConfig env where
  configL :: Lens' env Config

instance HasConfig Config where
  configL = id

class HasProjectTemplate env where
  projectTemplateL :: Lens' env Text

instance HasProjectTemplate Config where
  projectTemplateL = lens projectTemplate (\x y -> x {projectTemplate = y})

instance HasProjectTemplate Text where
  projectTemplateL = id

class HasTaskTemplate env where
  taskTemplateL :: Lens' env Text

instance HasTaskTemplate Config where
  taskTemplateL = lens taskTemplate (\x y -> x {taskTemplate = y})

instance HasTaskTemplate Text where
  taskTemplateL = id

getConfig :: IO Config
getConfig = error "todo"
