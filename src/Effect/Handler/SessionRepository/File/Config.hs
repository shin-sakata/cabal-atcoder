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
    createDirectoryIfMissing,
    doesDirectoryExist,
    getXdgDirectory,
  )
import System.Environment (lookupEnv)

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
  createDirectoryIfMissing True cacheDir
  pure $ cacheDir </> sessionFileName
  where
    getCacheDir :: IO FilePath
    getCacheDir = do
      cacheDir <- lookupEnv "CABAL_ATCODER_TEST_CACHE_DIR"
      case cacheDir of
        Nothing -> getXdgDirectory XdgCache "cabal-atcoder"
        Just "" -> getXdgDirectory XdgCache "cabal-atcoder"
        Just dir -> pure dir
