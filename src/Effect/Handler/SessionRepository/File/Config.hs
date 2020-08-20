{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Effect.Handler.SessionRepository.File.Config
  ( Config,
    HasSessionPath (..),
    getConfig,
  )
where

import Essential
import RIO.Directory
  ( XdgDirectory (XdgCache),
    createDirectory,
    doesDirectoryExist,
    getXdgDirectory,
  )
import System.Environment (getEnv)

data Config = Config
  { sessionPath :: !FilePath
  }

class HasSessionPath env where
  sessionPathL :: Lens' env FilePath

instance HasSessionPath Config where
  sessionPathL = lens sessionPath (\x y -> x {sessionPath = y})

instance HasSessionPath FilePath where
  sessionPathL = id

getConfig :: IO Config
getConfig = do
  sessionPath <- getSessionPath
  pure $ Config {sessionPath = sessionPath}

getSessionPath :: IO FilePath
getSessionPath = do
  let sessionFileName = "session"
  cacheDir <- getCacheDir
  initDir cacheDir
  pure $ cacheDir </> sessionFileName
  where
    initDir :: FilePath -> IO ()
    initDir dir = do
      exists <- doesDirectoryExist dir
      if exists
        then pure ()
        else createDirectory dir

    getCacheDir :: IO FilePath
    getCacheDir = do
      cacheDir <- getEnv "CABAL_ATCODER_TEST_CACHE_DIR"
      if null cacheDir
        then getXdgDirectory XdgCache "cabal-atcoder"
        else pure cacheDir
