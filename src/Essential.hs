module Essential (module Expose, maybeToMonadThrow, eitherToMonadThrow) where

import Control.Arrow ((|||))
import Control.Exception.Safe as Expose
import Control.Monad as Expose (void, when)
import Control.Monad.IO.Class as Expose
import Data.ByteString as Expose (ByteString)
import Data.Extensible as Expose hiding ((@=))
import Data.Extensible.Effect as Expose
import Data.Extensible.Effect.Default as Expose
import Data.Proxy as Expose (Proxy (Proxy))
import Data.String.Conversions as Expose (convertString)
import Data.Text as Expose (Text)
import Text.Shakespeare.Text as Expose (st)
import Prelude as Expose hiding (FilePath, (</>))
import System.FilePath as Expose (FilePath, (</>))

maybeToMonadThrow :: (MonadThrow m, Exception e) => e -> Maybe a -> m a
maybeToMonadThrow e = throw e `maybe` return

eitherToMonadThrow :: (MonadThrow m, Exception e) => Either e a -> m a
eitherToMonadThrow = throw ||| return
